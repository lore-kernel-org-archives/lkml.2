Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1CYPZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:25:42 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:54311 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751429Ab1CYPZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:25:41 -0400
X-Amavis-Alert: BAD HEADER SECTION, Improper folded header field made up
	entirely of whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n
	jycPrvgA\n\t\n R1goSzOnkp14Y[...]
Subject: Re: [git pull] drm fixes
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <Pine.GSO.4.62.1103250637570.6266@umail>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	 <1300864998.3522.71.camel@thor.local>
	 <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	 <1300868532.3522.81.camel@thor.local>
	 <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
	 <Pine.GSO.4.62.1103230633160.12612@umail>
	 <1300880747.16522.13.camel@thor.local>
	 <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
	 <Pine.GSO.4.62.1103240628490.1156@umail>
	 <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
	 <AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
	 <AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com>
	 <AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com>
	 <AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com>
	 <AANLkTim4jYfAFHkaHAWRU2uAzgRJLP1p1=5dugZgYkhS@mail.gmail.com>
	 <1301039010.12159.56.camel@thor.local>
	 <AANLkTik=+Vy_9_m6WQXePNn2P8c4dezOU4LSEDtj=PaU@mail.gmail.com>
	 <1301040045.12159.64.camel@thor.local>
	 <Pine.GSO.4.62.1103250637570.6266@umail>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Mar 2011 16:25:18 +0100
Message-ID: <1301066718.12159.116.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Removing Linus from CC, I doubt he's that interested in this anymore ]

On Fre, 2011-03-25 at 09:52 -0500, Ilija Hadzic wrote: 
> 
> * There is no way for an application to see the VBLANK events without
>    crossing into the kernel. VBLANKs are interrupts from the hardware
>    and only kernel knows them. Any userspace-only fix would be an ugly
>    hack (as Dave pointed) and maybe the application would look like it's
>    not stuck but it would not be doing the right thing no matter what you
>    do in the user space. So if I was fixing this, I figured I would do it
>    right. If anyone knows better than me and can technically prove (in
>    code, not in words) that an application can synchronize to (a correct)
>    VBLANK without calling the kernel, be my guest: submit your code and
>    evict mine.

It's not possible to synchronize correctly in this case, that's the
whole point. When userspace calls the ioctl for a different CRTC than
the one it's really interested in, that's (when it doesn't hang)
essentially making up a sequence number which doesn't necessarily have
any direct meaning for the CRTC userspace wants to synchronize to. I
suggested several other possibilities for making up sequence numbers in
that case without risking[0] a hang. But even if you don't want to go
into that, which is understandable to some degree, there's always the
simple option of not exposing this functionality to the X server at all
in this case.

[0] Or rather deliberately triggering, as userspace should know when
CRTC 1 is disabled.


> * Most comments about DDX pertained to old-kernel/new-userland
>    situation, which for most users using distros won't happen because
>    distros will make sure they have they have consistent packages.

Will they? As Dave pointed out, a new xf86-video-ati release with the
fix could be out at any time, but the kernel change could still take
months to make it into a distro kernel.


> * Saying that "kernel was not supposed to work with more two CRTCs" is
>    just plain wrong

That's not what I said.

There's no question that the kernel change will be necessary for all the
functionality to work perfectly on all CRTCs. But the hangs are mostly a
userspace issue and can be fixed there alone.


> And there is another point that Dave made that I fully support. To all of 
> you, I am a newcomer, and a plain garden-variety user who instead of 
> whining on Bugzilla and hoping that some hacker out there will show some 
> "mercy", actually stepped up to fix the problem (and to be allowed to do 
> that, I had to convince a few higher-ups that this would actually be in 
> the interest of those who write my paycheck). Some of you have shown 
> appreciation for that (thanks!), but some of you have seen it as an 
> opportunity to publicly prove that you are smarter than me (for which I 
> frankly don't care, as long as it does not impact the progress of the 
> development, but in this case it did).

That's your point of view. Mine is that your (certainly appreciated)
fixes had flaws that could have been easily and quickly resolved if you
had so chosen. Instead, you wasted a lot of everybody's time pushing
back and justifying the flaws rather than cooperating on a better
solution.

You won't have any trouble finding plenty of examples of newcomers
having a better experience, as most of them thankfully don't come in
with such a bad attitude and conduct.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
