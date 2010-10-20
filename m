Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0JTWsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:48:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52424 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab0JTWsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xweM4ZnpaeZb6UxVnUoPnHmJ6sIpmZQ+k40buNa6NPbcenCCi3tm7IOELpGyvKzgrd
         HGrCIlkAAEQfJBBooVShaI/4izv/74HGJCtjmRiNVSaVvCWz2ezERlGOPDEp/u7Xba3k
         ifEAV+MW3iLgNpmsUB+3HPDe17JPDz+xNF3ls=
MIME-Version: 1.0
In-Reply-To: <20101020223820.GB16331@suse.de>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
	<1287608139-21354-2-git-send-email-alchark@gmail.com>
	<20101020211643.GA10006@suse.de>
	<AANLkTikGiYvXgLs5eRQ9ghmatccBQJSdS3qwEHZN_3NF@mail.gmail.com>
	<20101020223820.GB16331@suse.de>
Date: Thu, 21 Oct 2010 02:48:34 +0400
Message-ID: <AANLkTim=-Qcmcp0qx_jj=yotO=Ur9-Oqc+UxkbEG=eo0@mail.gmail.com>
Subject: Re: [PATCH 2/6] serial: Add support for UART on VIA VT8500 and compatibles
From: Alexey Charkov <alchark@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/21 Greg KH <gregkh@suse.de>:
> On Thu, Oct 21, 2010 at 01:31:41AM +0400, Alexey Charkov wrote:
>> 2010/10/21 Greg KH <gregkh@suse.de>:
>> > On Thu, Oct 21, 2010 at 12:55:34AM +0400, Alexey Charkov wrote:
>> >> This adds a driver for the serial ports found in VIA and WonderMedia
>> >> Systems-on-Chip. Interrupt-driven FIFO operation is implemented.
>> >> The hardware also supports pure register-based operation (which is
>> >> slower) and DMA-based FIFO operation. As the FIFOs are only 16 bytes
>> >> long, DMA operation is probably not worth the hassle.
>> >>
>> >> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>> >> ---
>> >>
>> >> Please review and state whether this could be acceptable for a merge
>> >> to mainline in the coming 2.6.37 window.
>> >
>> > .37? ??Aren't you cutting it a bit close here? ??My trees unofficially
>> > closed a few days or so ago for new stuff to go to .37, what kept this
>> > from being sent previously?
>> >
>>
>> In fact, I'm somewhat new to kernel development, and have not yet
>> understood the good timings to do things properly.
>
> Please read the information in Documentation/development_process, it
> will help you out a lot.
>
>> My view was that the merge window is when new stuff should be
>> submitted, while everything in between is devoted to fixing breakage
>> just introduced.  So, I must have been wrong :)
>
> The merge window is for the subsystem maintainers, not the individual
> developers.  You need to have the code into a subsystem tree before the
> merge window in order to be able to get it accepted.
>
>> >> If possible, I would deeply appreciate a merge to a relevant git tree
>> >> for integration prior to asking Linus to pull the changes. I could
>> >> rebase the code if needed, currently this is against Linus' master
>> >> branch.
>> >>
>> >> This patch relies on the basic architecture support for VT8500/WM8505
>> >> to be in place, as introduced by PATCH 1/6 in this series.
>> >
>> > So it will just fail to build without that patch?
>> >
>>
>> It won't, and it should not even be selectable, as there is a Kconfig
>> dependency on the relevant arch. It's just that it would be useless
>> without the relevant arch support.
>
> That's good to know.
>
> As the .37 merge window just opened, you are going to have to wait until
> 2.6.37-rc1 before anyone will be able to have the time to review and
> accept these patches, sorry.  Please resend them then.
>
> thanks,
>
> greg k-h
>

Thanks for the directions, Greg! Probably we will have more things to
submit by then, so it does not really hurt.

Best regards,
Alexey
