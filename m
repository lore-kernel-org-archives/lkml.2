Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab1DYOxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:53:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47964 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab1DYOxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cbmz/oq85UMPYSE/InZv2s5/8BZb0pKWOyCgvKTo4t7bPcVwoy8QZdqZRdreBSSE8o
         G+cJ+zywq4YqIL/+p+HdZufwfkMvmOTbGXErQPjilgUaZw+gjaRls9RStct7EK0gC5BH
         DZYtnrSs9cIZTujVqVvRmW7l12m3567dcYvWs=
MIME-Version: 1.0
In-Reply-To: <4DB3EC35.7000601@fastmail.fm>
References: <4D7CCFC3.7030906@fastmail.fm>
	<AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>
	<AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>
	<4D7FD2FB.9090505@fastmail.fm>
	<AANLkTimboMAFkqTUOwP9m2z361TM_EgthQO07T5Y_az1@mail.gmail.com>
	<4D8118EB.2070209@fastmail.fm>
	<4D831E18.9020904@fastmail.fm>
	<4DB3EC35.7000601@fastmail.fm>
Date: Mon, 25 Apr 2011 10:53:46 -0400
Message-ID: <BANLkTingdS+OWM3FnzhzPKY72d2h7_+9Jw@mail.gmail.com>
Subject: Re: Radeon jittery post 2.6.35
From: Jerome Glisse <j.glisse@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: Alex Deucher <alexdeucher@gmail.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        xorg-driver-ati@lists.x.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 5:24 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>  On 03/18/11 09:55, Anders Eriksson wrote:
>>  On 03/16/11 21:09, Anders Eriksson wrote:
>> >  On 03/15/11 22:46, Alex Deucher wrote:
>> > >  Try booting with radeon.audio=0 on 2.6.38rc, some TVs have problems
>> > > with the hdmi packets we send by default.  disabling audio will treat
>> > > the hdmi like dvi.
>> > >
>> > > Alex
>> > You seem to be on to something there. radeon.audio=0 removes
>> > what appears to be all of the jitter. I say "appear", because during
>> > my many test runs today, I've come across moments where my brain
>> > goes "wasn't what I just noticed on the TV something abnormal?" Both
>> > in fb mode (post KMS), and in X11. It's definetly improved from useless
>> > for family use, to perfectly ok though.
>> >
>> I was too early on this one. Yesterday (.38) , and today (38-rc8),
>> are both jittery in post-KMS fb mode and in X, even though I use
>> radeon.audio=0.
>>
>> A power cycling of the TV stabilizes it though.
>>
>> I'd be more than happy to test out any patches or ideas you might have.
>>
>> -A
>
> It turns out all the failure patterns I've thought I've seen so far up
> through .38.x are moot.
>
> However, now on .39-rc, the KMS'd console is stable, and starting X
> makes it bad again.
>
> It there anything useful I can pull from any logs on the startup of X?
> Either from the X
> server, or the kernel. Last time I looked at the drm log from the kernel
> It was unreadable
> to a mere mortal, but I hope you guys can point me to what debug knobs
> to enable to get a good
> view of the interesting parts (How does one start a minimal X, btw?
> "xinit" gives me an
> undecorated xterm with the jitter. Can one start something more minimal?)
>
> Currently running today's git xorg-server and xf86-video-dri.
>
> -Anders
>
>

Best is to open a bug and attach xorg log & kernel dmesg.

https://bugs.freedesktop.org/

Cheers,
Jerome
