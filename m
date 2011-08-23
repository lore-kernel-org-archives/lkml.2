Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1HWJZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:25:53 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:56204 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754463Ab1HWJZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:25:50 -0400
Subject: Re: [RFC PATCH v2] Resurrect Intel740 driver: i740fb
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Date: Tue, 23 Aug 2011 11:25:33 +0200
In-Reply-To: <201108231103.30591.linux@rainbow-software.org>
References: <201108212242.12717.linux@rainbow-software.org>
	 <20110821233648.6d120143@lxorguk.ukuu.org.uk>
	 <201108231103.30591.linux@rainbow-software.org>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.0- 
Message-ID: <1314091533.21860.289.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2011-08-23 at 11:03 +0200, Ondrej Zary wrote: 
> On Monday 22 August 2011, Alan Cox wrote:
> > > - 24bpp modes still don't work in fbtest but it looks like fbtest bug!
> > >
> > > Is there any better way to test fb drivers than fbtest?
> >
> > X11 fbdev driver ?
> 
> Thanks, completely forgot about that. It works fine even in 24bpp.

Beware that Xorg defaults to 32 bpp for depth 24; did you verify in
Xorg.0.log that it was really using 24 bpp?


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
