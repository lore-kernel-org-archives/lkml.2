Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab1CWLqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:46:07 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:41153 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932242Ab1CWLqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:46:05 -0400
X-Amavis-Alert: BAD HEADER SECTION, Improper folded header field made up
	entirely of whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n
	jycPrvgA\n\t\n R1goSzOnkp14Y[...]
Subject: Re: [git pull] drm fixes
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Dave Airlie <airlied@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <Pine.GSO.4.62.1103230633160.12612@umail>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	 <1300864998.3522.71.camel@thor.local>
	 <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	 <1300868532.3522.81.camel@thor.local>
	 <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
	 <Pine.GSO.4.62.1103230633160.12612@umail>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Mar 2011 12:45:47 +0100
Message-ID: <1300880747.16522.13.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2011-03-23 at 06:40 -0500, Ilija Hadzic wrote: 
> On Wed, 23 Mar 2011, Dave Airlie wrote:
> 
> > 2011/3/23 Michel Dänzer <michel@daenzer.net>:
> >> On Mit, 2011-03-23 at 18:16 +1000, Dave Airlie wrote:
> >>> 2011/3/23 Michel Dänzer <michel@daenzer.net>:
> >>>> On Mit, 2011-03-23 at 04:18 +0000, Dave Airlie wrote:
> >>>>>
> >>>>> One radeon, 2 core fixes, and an interface update to allow for > 2 crtcs
> >>>>> in vblank.
> >>>>
> >>>> [...]
> >>>>
> >>>>> Ilija Hadzic (1):
> >>>>>       drm/kernel: vblank wait on crtc > 1
> >>>>
> >>>> This patch was still being debated yesterday, are you deliberately
> >>>> pushing it regardless? Once it hits mainline, it'll be pretty much set
> >>>> in stone.
> >>>
> >>> From what I can see it was the userspace patches being debated, this
> >>> one seemed fine and the interface looked okay to me.
> >>
> >> The author ignored my suggestions to make the patch smaller and simpler,
> >> more maintainable and more future-proof all at once.
> >
> > It was already small and I'm not sure merging the flags made it more
> > maintainable. Its always
> > being a slightly painful ioctl, and hopefully any future changes add a
> > new ioctl esp if we want 64-bit values.
> >
> > The only comment I really thought was necessary was changing the CAP
> > name, but since that isn't
> > part of the ABI (just the number) we can quickly fix it with a follow-up.
> >
> > Dave.
> 
> All of the issues debated yesterday, except one, boil down to renaming a 
> handful on #defines without changing the values nor interface nor behavior 
> of the kernel.

No, one central point is not to leave two holes between
_DRM_VBLANK_FLAGS_MASK, _DRM_VBLANK_HIGH_CRTC_MASK and
_DRM_VBLANK_TYPES_MASK .


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
