Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966446Ab0GSTTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:19:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58105 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965011Ab0GSTTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Kgzqc+QtN898VTk8vnpg/ILbj4XWu11I+ezPzKRtc58k/e6RBsNrLr0Kl8/SAyUq+4
         Dut6RX+j/4gjlyKtwc77nDv0i7mLul97HKCfrHbzJIaS+ki00wUmgquFFz0zVzFqvqVg
         AskuqVgTZ89DLPCGMnKYJkIfcg9ngztxQH9KI=
MIME-Version: 1.0
In-Reply-To: <4C447D6D.5060801@suse.cz>
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>
	<4C27E965.80508@gmail.com>
	<4C283D84.6080504@suse.cz>
	<20100628171410.GA27367@srcf.ucam.org>
	<4C290245.2040001@suse.cz>
	<20100628204820.GA32503@srcf.ucam.org>
	<AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>
	<4C2A3E27.4060407@suse.cz>
	<AANLkTimkElR1u-iRyFfCEQR5VTZvcyEIGQodfmFNtbC_@mail.gmail.com>
	<4C2B0C73.9050200@suse.cz>
	<4C3278C8.60503@gmail.com>
	<4C447D6D.5060801@suse.cz>
Date: Mon, 19 Jul 2010 13:19:04 -0600
Message-ID: <AANLkTin9_yEyMZImRbtKTvTeokks8dz0htQCu0B3RqXH@mail.gmail.com>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
From: Robert Hancock <hancockrwd@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:29 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>> I still no point in comparing this to Windows' setup. We can't find out
>>> whether it is quirked or better (without some bug) handled there.
>>
>> Well, you can see if Windows shows IRQ 10 or 11 for that device..
>
> But how can I find out which link it is routed to in Windows? Without
> that information the number is meaningless, no?

If you look at the pattern of which IRQs are shared by what devices in
Linux and compare it to Windows you can get a good idea. Normally the
assignment of devices to interrupt lines is hard-wired on the
motherboard and doesn't change.
