Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1BTEsz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 23:48:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44604 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1BTEsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 23:48:53 -0500
Date: Sat, 19 Feb 2011 20:47:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dustan Bower <dustan.bower@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: Re: [PATCH] Input: serio: Compile error fix (altera_ps2.c)
Message-Id: <20110219204750.88014cd8.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTinaVspNwHZFMUnbp=8F+K-=PRw95a1es+zyeCA+@mail.gmail.com>
References: <1298145859-10892-1-git-send-email-dustan.bower@gmail.com>
	<20110219214549.GA4933@core.coreip.homeip.net>
	<AANLkTinaVspNwHZFMUnbp=8F+K-=PRw95a1es+zyeCA+@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D609D30.0086:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011 20:04:49 -0700 Grant Likely wrote:

> On Sat, Feb 19, 2011 at 2:45 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Sat, Feb 19, 2011 at 03:04:19PM -0500, Dustan Bower wrote:
> >> Fixed compile error, today's linux-next tree:
> >>
> >>   CC [M]  drivers/input/serio/altera_ps2.o
> >> drivers/input/serio/altera_ps2.c:182:1: error: expected ‘,’ or ‘;’ before ‘extern’
> >> make[1]: *** [drivers/input/serio/altera_ps2.o] Error 1
> >> make: *** [_module_drivers/input/serio] Error 2
> >>
> >> Signed-off-by: Dustan Bower <dustan.bower@gmail.com>
> >
> > Thanks Dustan.
> >
> > Grant, maybe you could amend the original patch so that we do not
> > introduce bisection failure point?
> 
> done, thanks.

Hi Grant,

Did you also fix drivers/spi/spi_oc_tiny.c and
drivers/spi/spi_altera.c ?  I hit those build errors when
CONFIG_OF=y.  Could there be others?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
