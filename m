Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1ALNzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:55:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64727 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1ALNzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:55:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W1lg8r0xxprEUj7m/JzzNVEic0D4nonDcdilIPOAdhV3H0NT69McabH0qWzwWsgHU4
         mgaWh3Zpx4jBuGQFXfV+TET6gTp4tQieP69b3PqIPNCpVDGpmz5mpuIC4Rxa1dUBSNeC
         jBnjwzNWvmGSznMMcD3D4T/QeYVTY5KS9uY8o=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101121344070.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<4D2CE5C8.60601@de.ibm.com>
	<AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com>
	<4D2D8ED0.6080807@de.ibm.com>
	<AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
	<alpine.LFD.2.00.1101121344070.8212@casper.infradead.org>
Date: Wed, 12 Jan 2011 15:55:05 +0200
Message-ID: <AANLkTikEWuNYuZegH0=sVzL21FAH7S16-ZzxtCoG7+Jo@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Anca Emanuel <anca.emanuel@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 3:45 PM, James Simmons <jsimmons@infradead.org> wrote:
>
>> On Wed, Jan 12, 2011 at 1:21 PM, Christian Borntraeger
>> <borntraeger@de.ibm.com> wrote:
>> > Am 12.01.2011 00:28, schrieb Linus Torvalds:
>> >> On Tue, Jan 11, 2011 at 3:20 PM, Christian Borntraeger
>> >> <borntraeger@de.ibm.com> wrote:
>> >>>
>> >>> Now nouveau framebuffer is completely broken on my T61p (01:00.0 VGA compatible controller: nVidia Corporation G84M [Quadro FX 570M] (rev a1))
>> >>> During startup the framebuffer shows only stripes and a blank
>> >>> screen after suspend/resume.
>> >>> I also see lots of TRAP messages. (see below).
>> >>> X11 seems to work fine though...
>> >>
>> >> Can you try to bisect?
>> >
>> > dfe63bb0ad9810db13aab0058caba97866e0a681 is the first bad commit
>> > commit dfe63bb0ad9810db13aab0058caba97866e0a681
>> > Author: James Simmons <jsimmons@infradead.org>
>> > Date:   Thu Dec 23 16:40:37 2010 +0000
>> >
>> >    drm: Update fbdev fb_fix_screeninfo
>> >
>> >
>> > Reverting this on top of todays git also fixes my problem.
>> >
>> > Christian
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>>
>> I tested the revert: the boot screen did change the resolution
>> (without it don't), but my PC still hangs. (using an nvidia 8800GT).
>
> Try my most recent patch. Where does it hang at? Any logs?
>

My keyboard is not working, I can not make an log.
I see 'something' on the screen, I hear the boot song sometimes.

I will test it your parch, but for me it will take over 1 hour.
