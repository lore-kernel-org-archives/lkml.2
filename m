Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0IMN6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:58:46 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:35336 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751815Ab0IMN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:58:45 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: GIOR2KkVM1nDJB_cRG.EgmQUAcpFhaVzzAk0lxMgUlZXcKy
 e0Dwgq_Q3FxqAdBuvsnh0VmOLDOc2d6Pp8OTauqdHQTINrNHF4tKAqISuMC8
 MF16lrfLM8jeeW4uIaB9rZ8FKmV63Ho49MF.DeiJ3WrJKOyW6s1nxOyb.Hmp
 yPnqiTZQtvdfUqTBNS07xF7jMN24Exs7gQD_ihrtzNPuc8NGgHBxdgm9Z0d4
 jvOr7fGbm5TK_NFSYa2F9Q5lqF8UE
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 13 Sep 2010 08:58:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Walleij <linus.ml.walleij@gmail.com>
cc: linux kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, tj@linux.com,
        =?ISO-8859-15?Q?Jonas_=C5berg?= <jonas.aberg@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regression on UP ARM from commit
 e18d65f0500b95d8724b17d8ea9f1116cf390bbe
In-Reply-To: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1009130855430.26275@router.home>
References: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Sep 2010, Linus Walleij wrote:

> commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
> "slub: Remove static kmem_cache_cpu array for boot"
> made my ARM 926 UP system hang at boot, if I revert this (have
> to back out a lot of SLUB patches for that) it comes back up. (Same if I
> switch to SLAB.)
>
> Any hints on how I can get patch around this in a nice way?

This is UP right? Any more details on this one? Does ARM have
earlyprintk?

Tejun also has some patches that make the percpu allocator work on UP so
that we do not need the hack (you must have the hack which is commit
c23e5ad729ac43f5e2fbc080f94cf61f07b4d45f as well to make UP work right!).

I am not sure if they are already in -next though.


