Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1LUI1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:27:54 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:36146 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751568Ab1LUI1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:27:49 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Dec 2011 03:27:48 EST
Message-ID: <1324455480.1807.153.camel@thor.local>
Subject: Re: 3.2-rc6+: Reported regressions from 3.0 and 3.1
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Date: Wed, 21 Dec 2011 09:18:00 +0100
In-Reply-To: <201112210039.14100.linux-pm-bounces@lists.linux-foundation.org>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
	 <201112210039.14100.linux-pm-bounces@lists.linux-foundation.org>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2011-12-21 at 00:39 +0100, Rafael J. Wysocki wrote: 
> 
> Subject    : [BUG] 3.2-rcX radeon KMS system freeze
> Submitter  : Bob Tracy <rct@gherkin.frus.com>
> Date       : 2011-11-25 20:33
> Message-ID : 20111125203351.GA3651@gherkin.frus.com
> References : http://marc.info/?l=linux-kernel&m=132225331312019&w=2

Is that really a (recent) regression? It sounds like Bob's only getting
things working for the first time, and I can't see any mention of a
previous working kernel version.

Anyway, might be worth following up on this on the dri-devel list with
more information, e.g. the dmesg output and Xorg.0.log corresponding to
the freeze.


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
