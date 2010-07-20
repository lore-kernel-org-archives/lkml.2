Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab0GTGAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 02:00:14 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:50825 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754693Ab0GTGAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 02:00:12 -0400
X-Quarantine-ID: <L8Ayj7xgeWKb>
X-Amavis-Alert: BAD HEADER, Improper folded header field made up entirely of
	whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n jycPrvgA\n\t\n
	R1goSzOnkp14Y[...]
Subject: Re: Regression 2.6.34+ -> 2.6.34-rc5: radeon KMS rs780 problems
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <201007192300.15124.edt@aei.ca>
References: <201007171856.39564.edt@aei.ca>
	 <1279550060.9986.89.camel@thor.local>  <201007192300.15124.edt@aei.ca>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Jul 2010 08:00:06 +0200
Message-ID: <1279605606.9986.113.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 23:00 -0400, Ed Tomlinson wrote: 
> On Monday 19 July 2010 10:34:20 Michel Dänzer wrote:
> > On Sam, 2010-07-17 at 18:56 -0400, Ed Tomlinson wrote: 
> > > 
> > > My 790gx chipset supplies an rs780.  With .34+ all is ok.
> > > With .35-rc5 basic function seems ok (kde works) but games like
> > > extreme tux racer have problems.  The cursor does not display when on
> > > the tux racer window and various objects flicker on and off as I
> > > attempt to play the game.   
> > 
> > Sounds like it might be
> > https://bugs.freedesktop.org/show_bug.cgi?id=28341 . Does the X driver
> > patch attached there fix the problem?
> 
> Michel,
> 
> xf86-video-ati git from today fails.  Applying the revert patch in the above message
> fixes the problem.  Its an interesting bug in that the kernel change triggers the 
> driver bug.  Might be a good idea to get this fixed, one way or another, before
> -35 gets released?

It's basically a userspace bug, the buggy userspace code is just only
active with new functionality in the new kernel.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
