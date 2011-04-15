Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1DOI1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:27:13 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:37820 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802Ab1DOI1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:27:10 -0400
Subject: Re: Linux 2.6.39-rc3
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Joerg Roedel <joro@8bytes.org>
Cc: Alex Deucher <alexdeucher@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 15 Apr 2011 10:26:34 +0200
In-Reply-To: <20110414210932.GG18463@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
	 <20110412090207.GE19819@8bytes.org>
	 <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
	 <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu>
	 <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org>
	 <4DA654D6.2060103@zytor.com> <20110414085624.GC18463@8bytes.org>
	 <BANLkTintewt4kadNLEZ-RAew0Gx6=gUOfQ@mail.gmail.com>
	 <20110414210932.GG18463@8bytes.org>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.0- 
Message-ID: <1302855994.15520.158.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2011-04-14 at 23:09 +0200, Joerg Roedel wrote: 
> On Thu, Apr 14, 2011 at 10:28:43AM -0400, Alex Deucher wrote:
> > On Thu, Apr 14, 2011 at 4:56 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > > And this makes a difference, with this change on-top of -rc3 the box boots
> > > fine. So there seems to be some dependency between the GART base and the GTT
> > > base even when they are in different address spaces.
> > >
> > > Alex, can you comment on this?
> > 
> > As Dave said, they are completely different addresses spaces.  You
> > could put the GPU aperture at 0 if you wanted (in fact we do on some
> > chips).  Perhaps there's some strange interaction with the nb gart
> > since the nb gart on that chipset was designed to be used for graphics
> > and the rs780/880 can be configured to use an agp aperture.
> > Unfortunately, I'm not that familiar with the nb gart.
> 
> Actually, the nb gart is part of the cpu. It is part of the cpu north
> bridge and can translate io and cpu accesses. In fact, it is a remapper
> of physical memory addresses.
> 
> The problem seems to be related to specific gpu chips. On another
> notebook with an hd3000 card gtt and the nb gart aperture are both on
> 0xa0000000 too but the box works fine.

Wasn't the working theory that the problem occurs if those two values
aren't the same?


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
