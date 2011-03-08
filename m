Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1CHKu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:50:27 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:35530 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752627Ab1CHKuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:50:25 -0500
X-Greylist: delayed 738 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Mar 2011 05:50:25 EST
X-Amavis-Alert: BAD HEADER SECTION, Improper folded header field made up
	entirely of whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n
	jycPrvgA\n\t\n R1goSzOnkp14Y[...]
Subject: Re: [regression] 2.6.37-post-rc7 with radeon kms: reproducably
 locks up hard when using desktop cube of kwin
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        DRI <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTim8kRi8twRJmAZRQs6WhJin8cMMp70mBV+cpLQX@mail.gmail.com>
References: <201103051510.35057.Martin@lichtvoll.de>
	 <201103062020.21959.Martin@lichtvoll.de>
	 <AANLkTinhx12_HvDq3Mp7xrkrCez90pNiSuh7KrJAmFXp@mail.gmail.com>
	 <201103081035.24459.Martin@lichtvoll.de>
	 <AANLkTim8kRi8twRJmAZRQs6WhJin8cMMp70mBV+cpLQX@mail.gmail.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Mar 2011 11:37:49 +0100
Message-ID: <1299580669.14068.219.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2011-03-08 at 19:40 +1000, Dave Airlie wrote: 
> On Tue, Mar 8, 2011 at 7:35 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Its rainy again in Sevilla...
> >
> > Am Sunday 06 March 2011 schrieb Dave Airlie:
> >> > I verified this. Lockup happens with 2.6.38, last one tested
> >> > rc8-gfb62c00, but not with 2.6.37 with exactly same userspace.
> >> > Needed to try the effect several times, as this time the lockup with
> >> > 2.6.38 only happened shortly after the second activation of the
> >> > effect.
> >>
> >> Hmm, can you attach Xorg logs from both?
> >
> > Attached. I have dmesgs available as well. Both kernels are mainly
> > upstream. The 2.6.37 contains some recursive mtime patches from Jan for
> > Ext3/4 that are very likely unrelated. For 2.6.38 I am testing too
> > hibernation patches from Raphael, but the lockup also happened with a
> > plain vanilla 2.6.38 one before.
> >
> >> I'm guessing its either pageflipping or a later kernel allowing some
> >> feature of mesa to be used.
> 
> Okay can you try using an xorg.conf with Option "pageflip" "false" set
> in it for the radeon.

That should be

Option "EnablePageFlip" "false"


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
