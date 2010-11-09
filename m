Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0KIKww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:52:52 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:56910 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755169Ab0KIKwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:52:49 -0500
X-Amavis-Alert: BAD HEADER SECTION, Improper folded header field made up
	entirely of whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n
	jycPrvgA\n\t\n R1goSzOnkp14Y[...]
Subject: Re: Radeon RS780 - BUG: unable to handle kernel NULL pointer
 dereference
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
In-Reply-To: <20101109103737.GA1767@arch.trippelsdorf.de>
References: <20101108170221.GA1602@arch.trippelsdorf.de>
	 <20101108170737.GA1617@arch.trippelsdorf.de>
	 <20101108184301.GA1614@arch.trippelsdorf.de>
	 <20101108190258.GA1623@arch.trippelsdorf.de>
	 <AANLkTi=fo3rnBp8Fs6H+ivP6R+x=QDzBLyi+DmT-LNHV@mail.gmail.com>
	 <4CD879BC.5060008@vmware.com> <20101109092920.GA1542@arch.trippelsdorf.de>
	 <4CD91A07.1060308@vmware.com> <4CD91D58.7080508@vmware.com>
	 <1289298777.10682.63.camel@thor.local>
	 <20101109103737.GA1767@arch.trippelsdorf.de>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 11:52:27 +0100
Message-ID: <1289299947.10682.68.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2010-11-09 at 11:37 +0100, Markus Trippelsdorf wrote: 
> On Tue, Nov 09, 2010 at 11:32:57AM +0100, Michel Dänzer wrote:
> > On Die, 2010-11-09 at 11:07 +0100, Thomas Hellstrom wrote: 
> > > On 11/09/2010 10:53 AM, Thomas Hellstrom wrote:
> > > > On 11/09/2010 10:29 AM, Markus Trippelsdorf wrote:
> > > >> OK I've found the buggy commit by bisection:
> > > >>
> > > >> e376573f7267390f4e1bdc552564b6fb913bce76 is the first bad commit
> > > >> commit e376573f7267390f4e1bdc552564b6fb913bce76
> > > >> Author: Michel Dänzer<daenzer@vmware.com>
> > > >> Date:   Thu Jul 8 12:43:28 2010 +1000
> > > >>
> > > >>      drm/radeon: fall back to GTT if bo creation/validation in VRAM 
> > > >> fails.
> > > >>
> > > >>      This fixes a problem where on low VRAM cards we'd run out of 
> > > >> space for validation.
> > > >>
> > > >>      [airlied: Tested on my M7, Thinkpad T42, compiz works with no 
> > > >> problems.]
> > > >>
> > > >>      Signed-off-by: Michel Dänzer<daenzer@vmware.com>
> > > >>      Cc: stable@kernel.org
> > > >>      Signed-off-by: Dave Airlie<airlied@redhat.com>
> > > >>
> > > >> Please note that this is an old commit from 2.6.36-rc. When I revert 
> > > >> it the
> > > >> kernel no longer crashes. Instead I see the following in my dmesg:
> > > >>
> > > >
> > > > Hmm, so this sounds like something in the Radeon eviction error path 
> > > > is causing corruption.
> > > > I had a similar problem with vmwgfx, when I tried to unref a BO 
> > > > _after_ ttm_bo_init() failed.
> > > > ttm_bo_init() is really supposed to call unref itself for various 
> > > > reasons,  so calling unref() or kfree() after a failed ttm_bo_init() 
> > > > will cause corruption.
> > > >
> > > > In any case, the error below also suggests something is a bit fragile 
> > > > in the Radeon driver:
> > > >
> > > > First, an accelerated eviction may fail, like in the message below, 
> > > > but then there must always be a backup plan, like unaccelerated 
> > > > eviction to system. On BO creation, there are a number of placement 
> > > > strategies, but if all else fails, it should be possible to initially 
> > > > place the BO in system memory.
> > > >
> > > > Second, If bo validation fails during a command submission, due to 
> > > > insufficient VRAM / TT, then the driver should retry the complete 
> > > > validation cycle after first blocking all other validators and then 
> > > > evicting everything not pinned, to avoid failures due to fragmentation.
> > > >
> > > > /Thomas
> > > >
> > > 
> > > Indeed, it seems like the commit you mention just retries ttm_bo_init() 
> > > after it previously failed. At that point the bo has been destroyed, so 
> > > that is probably what's causing the BUG you are seeing.
> > > 
> > > Admittedly, ttm_bo_init() calling unref on failure is not properly 
> > > documented in the function description.  The reason for doing so is to 
> > > have a single path for freeing all BO resources already allocated on the 
> > > point of failure.
> > 
> > Does the patch below fix the problem?
> 
> Yes, indeed. I was just about to send the same patch to the list.
> 
> Thanks.

Thank you for testing / confirming the fix, and to Thomas for the
analysis of the problem.

I've submitted the fix to Dave with your Tested-by: added.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
