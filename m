Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1DNJD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:03:26 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:47503 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932142Ab1DNJDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:03:14 -0400
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: kevin diggs <diggskevin38@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mikael Pettersson <mikpe@it.uu.se>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Apr 2011 11:02:36 +0200
In-Reply-To: <BANLkTika8FY1dD_hOQ4wMhHzuQ2Qt8fg7A@mail.gmail.com>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	 <1302646173.28876.53.camel@pasglop> <1302652502.28876.76.camel@pasglop>
	 <19877.23529.745123.819112@pilspetsen.it.uu.se>
	 <1302685102.28876.81.camel@pasglop>
	 <BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>
	 <1302736869.28876.91.camel@pasglop>
	 <BANLkTika8FY1dD_hOQ4wMhHzuQ2Qt8fg7A@mail.gmail.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.0- 
Message-ID: <1302771756.15520.100.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2011-04-13 at 18:43 -0500, kevin diggs wrote: 
> 
> On Wed, Apr 13, 2011 at 6:21 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Wed, 2011-04-13 at 12:52 -0500, kevin diggs wrote:
> >> > Actually I do get a crash in X later on... something in the radeon
> >> DRM
> >> > interrupt code is getting what looks like a NULL dereference. I'll
> >> try
> >> > to dig that one later on. I don't know if it's related to your
> >> problem
> >> > at all though.
> >> >
> >> In this context, what does 'crash' mean? The X thingy goes down? Or
> >> the whole OS?
> >
> > Depends, with xmon enabled you get into xmon :-) Dunno if the oops is
> > fatal but it could be.
> >
> > Cheers,
> > Ben.
> >
> >
> 
> As I think I have the same hardware as you (7,3, radeon 9600) If you
> can tell me how to reproduce it maybe I can poke around a little.
> Thus, at least temporarily, freeing you up for other stuff.
> 
> I kinda need a break from fighting with GCC.

FWIW, the problem Ben refers to might be fixed in current mainline by
commit d87dfdbfc91c5e37288e7e8f7afdd992ba61a60d which reverts
69a07f0b117a40fcc1a479358d8e1f41793617f2 .


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
