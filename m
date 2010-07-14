Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab0GNOqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:46:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54432 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab0GNOqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DuvHUm5PcmhDU47fTQApaHGUqqoCqVGzv6qD4KfbBhZTMKyKHW0hyH6eXUIeBnIioD
         O3wRsk6wmIfVuWXZ42nC8+QrlomJtnPhLpBKARcbsjDM0b5V0e87LECgNkmUaZHSSoux
         wj74ad0PFIzzD9OZ6GYfpLIGbx8N8FF10V5tQ=
MIME-Version: 1.0
In-Reply-To: <20100714143625.GA30721@srcf.ucam.org>
References: <4C3DCAA4.9050602@gmail.com>
	<20100714143625.GA30721@srcf.ucam.org>
Date: Wed, 14 Jul 2010 15:46:46 +0100
Message-ID: <AANLkTikHjd3SZKCdTABO7Aw_Y1BMC2EYJTvLD83Ta34r@mail.gmail.com>
Subject: Re: [PATCH] Remove 9 second reboot delay on Lenovo T400/T500
From: Pedro Ribeiro <pedrib@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        toralf.foerster@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 July 2010 15:36, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jul 14, 2010 at 03:33:08PM +0100, Pedro Ribeiro wrote:
>>  Please consider this patch. Let me know if you would like me to change
>>  anything or if you don't agree with it. It applies cleanly to 2.6.35-rc5.
>>
>>  The Lenovo T400 and T500 have an annoying 9 second delay when
>>  rebooting, unless reboot=pci is passed to the kernel command line.
>>  This delay happens from at least kernel 2.6.20.
>>
>>  Make this change permanent by hardcoding the Tx00 on the
>>  arch/kernel/reboot.c pci quirks table.
>
> There's two possibilities here:
>
> 1) Lenovo's firmware is broken and the 9-second delay is always going to
> be there. In that case we should try to use the ACPI reboot vector
> first.
>
> 2) We're doing something wrong in our shutdown sequence which then
> triggers this problem as a result.
>
> Either way, I think this patch is wrong.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

Hi Matthew,

by acpi reboot vector you mean using reboot=acpi?
I tried it and does not solve the problem.
Check here http://marc.info/?l=linux-kernel&m=127590255224570&w=2

Can you please tell me how to debug this?

Thanks,
Pedro
