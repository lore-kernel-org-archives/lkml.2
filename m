Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1GFPa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:30:59 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:36352 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753236Ab1GFPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:30:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 7RT.cXMVM1l9g171xT2tPli3i7ipL2b5Xp3oqRTZ13UsBaU
 sBpVOCway5BTQzAmYv6uik8c7NUb0ScaR3N0ZJ_fYSmXfxjIdVzD2VvcCHuU
 tNjzsiKazQg8.TA4HXvBCGr_pQba1g6piKg8CVLzXHZFO7L8KIzd1A19HxXi
 Z_AwuCMAbHW.mlO7VEgM.7ThCE_LFXMo2yU_W7FDHP58NdG7ZpOFWulk4n5N
 EmUnFkby2FHPPr_CFuDqPVl5eDRGPyNpz2s73eqj8T5YSkyAfZDBmN8Jjbm0
 VLwU.pji2t9x4pWgtAjVgWocVaRFdxCB4ttC5c9CBdhOt2CE-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Jul 2011 10:30:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Kruse <pk@q-leap.de>
cc: Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
        David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <4E147C0A.4080008@q-leap.de>
Message-ID: <alpine.DEB.2.00.1107061030190.17624@router.home>
References: <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com> <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com>
 <4DA54D2A.3050206@q-leap.de> <alpine.DEB.2.00.1104131116330.19493@router.home> <4E09BEA1.1080501@q-leap.de> <alpine.DEB.2.00.1107051013500.16869@router.home> <20110705172043.GA15147@csn.ul.ie> <20110706041602.GX1026@dastard> <4E1405C3.20904@q-leap.de>
 <alpine.DEB.2.00.1107060931190.17202@router.home> <4E147C0A.4080008@q-leap.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Peter Kruse wrote:

> > Note that this is *not* the original problem you reported. I do not see
> > page alloc failures in your latest logs.
> >
>
> yes, I see.  Maybe originally there were two problems of which one is
> now solved?

That could be the case. Please run the latest 2.6.32 as requested by Mel.

