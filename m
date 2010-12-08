Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0LHVrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:47:21 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:25962 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752512Ab0LHVrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:47:20 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: YjM2d2oVM1kUl7d.cPUp93vZTvkcPSvY.Sd.zs192dy2hS_
 IWKAx.ANSB9qfn7strfyQ6evt_7gno1E.pecqSZgdbC_YtH2pvU9ezmeifdX
 Gn3FolcN7dPGRo8XyHAQ_6Q4dev5xtERO_bQSXrKLS_K0soissvZk3B9Jg1O
 8wpTrqrB4tsBTynzkUhFbE5jUNqdJTq6aRjVhmswh6VsAymXkzuGiIs0XSUK
 eSjwpIUeCerInVux0_GSunYfPyHpi56O2NgI.DA--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Dec 2010 15:47:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] printk: Use this_cpu_{read|write} api on
 printk_pending
In-Reply-To: <tip-40dc11ffb35e8c4e8fa71092048e0f8de9db758c@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1012081546170.28112@router.home>
References: <1290788536.2855.237.camel@edumazet-laptop> <tip-40dc11ffb35e8c4e8fa71092048e0f8de9db758c@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 8 Dec 2010, tip-bot for Eric Dumazet wrote:

> printk: Use this_cpu_{read|write} api on printk_pending

One of the patches in Tejun's percpu tree includes the same modifications.


