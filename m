Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0LVHz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 02:55:57 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:45373 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752401Ab0LVHz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 02:55:56 -0500
X-Amavis-Alert: BAD HEADER SECTION, Improper folded header field made up
	entirely of whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n
	jycPrvgA\n\t\n R1goSzOnkp14Y[...]
Subject: Re: [PATCH] drm/radeon: Remove DRIVER_DATE for UMS and KMS
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: sedat.dilek@gmail.com
Cc: Dave Airlie <airlied@gmail.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTik7SQ76zcAMk5=mgKRF7MWghVHhLtY1CtK-WPKy@mail.gmail.com>
References: <AANLkTik7SQ76zcAMk5=mgKRF7MWghVHhLtY1CtK-WPKy@mail.gmail.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 08:55:39 +0100
Message-ID: <1293004539.19556.70.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-12-22 at 08:38 +0100, Sedat Dilek wrote: 
> 
> sorry, I still haven't setup a git-send-mail, thus sending the
> old-fashioned way as attached patch.

Your mailer might allow integrating the output of git format-patch into
the mail body directly instead.

> This patch (against linux-next) is overdue.
> 
> "DRIVER_DATE is not maintained or upgraded on changes.
> 
> Furthermore, one DRIVER_DATE for UMS and KMS makes no sense.
> It is enough to bump {KMS_}DRIVER_MAJOR, {KMS_}DRIVER_MINOR and
> {KMS_}DRIVER_PATCHLEVEL defines."

What ends up being printed as the date in dmesg?


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
