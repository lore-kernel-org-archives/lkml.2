Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1GGSnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:43:03 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25416 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755777Ab1GGSnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:43:00 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: BvBQm2AVM1lDihm37rKLez5cnCEBkFCoXEMeWnybTwgjtb8
 WnCQduGz56njQR0jxQ_DIjGNjpf75_BPa7JWNG0lBVV_6cuuwtMXlUR_Lkpu
 YULqmssc.6KeF2gVvgqV_Ez2ScqLQkuV7uEY9651fURQXNGu85GgmD9rrMUq
 yKrSqsi2v4Fjy7wifdjSsyDeQvNvEPmUErvM6RKcIQ2_ZiZDbnJ4QvUCFtSJ
 XjxcclZ42X1I.r7BVBLAN4X74VzBx9Dr.ojmR9UM0gGk_nk_mRBSf.SyKwpl
 Dcifm.Dm.BdtENl7xFviYnXLCl.UB4V1uRxKTqZG4yaH.RUch
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Jul 2011 13:42:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ben Greear <greearb@candelatech.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        rientjes@google.com, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <4E15FB3E.9050108@candelatech.com>
Message-ID: <alpine.DEB.2.00.1107071341120.21719@router.home>
References: <20110626193918.GA3339@joi.lan> <alpine.DEB.2.00.1107072106560.6693@tiger> <alpine.DEB.2.00.1107071314320.21719@router.home> <4E15FB3E.9050108@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Ben Greear wrote:

> The more painful you make it, the less likely folks are to use it
> in environments that actually reproduce bugs, so I think it's quite
> short-sighted to reject such performance improvements out of hand.
>
> And what if some production machine has funny crashes in a specific
> work-load....wouldn't it be nice if it could enable debugging and
> still perform well enough to do it's job?

Sure if there would be significant improvements that accomplish what
you claim above then that would be certainly worthwhile. Come up with
patches like that please.


