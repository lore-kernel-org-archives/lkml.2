Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1BYLfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:35:18 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36519 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1BYLfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:35:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CoQX/UxBRCEHJ4wUDxFGRYtmmoE50OYM+2mN2G/ubHTOo75EzUxxpKHe9qw0Fs9zv8
         Ffx+xX9r5E6UCQqCJzviBnXlnlHdn9QZ6Oc9XnFdNxX7LN3tM63aBKsG+JATDMFMfP7o
         hx2vD6mFjOcld4L2121cJrCqnjjXbKhScS6jI=
MIME-Version: 1.0
In-Reply-To: <33d9e1abc0d731efa7ba1461b0883c9f.squirrel@webmail.greenhost.nl>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
	<AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
	<0d30dc$l7ehaa@orsmga001.jf.intel.com>
	<AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
	<b5f94200cffe31ff8cbe38d2bd2e35a7.squirrel@webmail.greenhost.nl>
	<AANLkTimLb4=04vOU7_SrtKpWQvFmDfibHGGsC+CFxwCW@mail.gmail.com>
	<1cced1eb38110129d097e1c8b6857d81.squirrel@webmail.greenhost.nl>
	<AANLkTi=9hq9JPUHRNWaxRe2txdguWw61mrJHjanNPG94@mail.gmail.com>
	<33d9e1abc0d731efa7ba1461b0883c9f.squirrel@webmail.greenhost.nl>
Date: Fri, 25 Feb 2011 12:35:15 +0100
Message-ID: <AANLkTimm=bnOUvipL1czJCpP9Oe9QzDQMkXDk0bPUaP9@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Alex Riesen <raa.lkml@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 12:07, Indan Zupancic <indan@nul.nu> wrote:
> On Fri, February 25, 2011 11:18, Alex Riesen wrote:
>> So far I found only two patches (and three changes):
>>
>> This is the first:
>>
>> Corruption caused by portions of the screen stopped updating (the Bug 27572).
>> Certainly worked around by returning -EINVAL for ..RELAXED_FENCING.
>
> This is fixed in a better way by Daniel's latest patch.
>

Precisely which is it? Just copy the text of the patch you have
in mind here. Because I don't fscking understand what are talking
about, man!
