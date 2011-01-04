Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1ADVPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:15:44 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37912 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1ADVPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NUSK/GZSETbdhDCqD9Aiml2cD6ogwCDdeJvsbWxAPHC3Q3thhKJUjQapbpFjhRuIw+
         NWTLz2+8QPJ28OBUMOGds0nDgIemKHwyiOU0mIQf+Ik7ZcYLQXKgpRxksu7STJMsL2gR
         umQf3qYi/Bs98RTFiiDqYlCThCs7MJ+1SSXrg=
MIME-Version: 1.0
In-Reply-To: <20110104210408.GA2008@elf.ucw.cz>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20110104142604.GA6591@ucw.cz>
	<849307$b0n4jp@azsmga001.ch.intel.com>
	<20110104210408.GA2008@elf.ucw.cz>
Date: Wed, 5 Jan 2011 07:15:42 +1000
Message-ID: <AANLkTim2PC5tgLfuz4+jO4L_xSX9bPuLhy+gtE2mgcJH@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8
From: Dave Airlie <airlied@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 7:04 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > I still see blank screen on thinkpad x60... but so do I on 2.6.36 with
>> > same config, so maybe it is just tricky to configure?
>>
>> Old bug? I thought we had KMS on 945 pretty well understood by now. Care
>> to attach the dmesg with drm.debug=0xe? And to check against linus/master
>> for the most recent regression fixes.
>
> dmesg is attached (delme.gz), as is config.
>
> And yes, I did git pull few minutes ago...
>                                                                        Pavel
> --

Disable CONFIG_FB_VESA or remove the vga= line from the commandline for a
first test.

Dave.
