Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab0JZOzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:55:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62425 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0JZOzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Trkw/x04m+vgWChh81wHt+Zc2kXBcH4rDZQK+jzdje8Gq8nKJ1bK1bhOOyEAaR7hnb
         yFgqXcekZQRH8XZHLXOmZvjteqG4/62V+C7G2Mt6adPqeWAw5Wy7MaKLxx/ORez6m6cK
         dBq0hAjbQ7/t5YGQmOdopPQFH0itNc8Yx27Tg=
MIME-Version: 1.0
In-Reply-To: <1288103059-notmuch-felipe.contreras@nokia.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
	<20101026040619.GA8549@suse.de>
	<1288103059-notmuch-felipe.contreras@nokia.com>
Date: Tue, 26 Oct 2010 09:55:39 -0500
X-Google-Sender-Auth: 49qSOP2nhdQc3xg_nU1NTsyWOo4
Message-ID: <AANLkTimgpj3iU3xQ8K7iwjMuaH3efgzsZfkzZU-H8Fxc@mail.gmail.com>
Subject: Re: [PATCH 0/8] staging: tidspbridge - misc fixes
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: gregkh@suse.de, x0095840@ti.com, hiroshi.doyu@nokia.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 9:43 AM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> gregkh@suse.de wrote:
>> On Mon, Oct 25, 2010 at 07:51:38PM -0500, Fernando Guzman Lugo wrote:
>> > This set of patches fix some issues found in lastest tree.
>> >
>> > Fernando Guzman Lugo (8):
>> >   staging: tidspbridge - remove req_addr from proc_map
>> >   staging: tidspbridge - add kconfig parameter for DMM size
>> >   staging: tidspbridge - change mmufault tasklet to a workqueue
>> >   staging: tidspbridge - fix timeout in dsp_gpt_wait_overflow
>> >   staging: tidspbridge - use GTP7 for DSP stack dump
>> >   staging: tidspbridge - remove disabling twl when printing DSP stack
>> >   staging: tidspbridge - fix some issues after iommu patches
>> >   staging: tidspbridge - make sync_wait_on_event interruptible
>>
>> Are any of these really applicable for .37 after .37-rc1?  Or can they
>> wait for .38?
>
> As of right now the dspbridge doesn't work, and there's a mess of
> dependencies to get it working.

Just to note that there will be one more dependency for SCM changes[1]
that will fix compilation, as these need to climb from linux-omap (if
accepted) before applying tidspbridge chunks.

Regards,
Omar

---
[1] http://marc.info/?l=linux-omap&m=128779652429922&w=2
