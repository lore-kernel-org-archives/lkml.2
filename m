Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2ERPhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:37:47 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:26660 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755043Ab2ERPhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:37:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: d4cY8ooVM1looi6wMFBxAWY9eX8ZRe_3H0ryUOeNpqzdlgT
 MWGzTLkaHYvW5yw_ZRG_VPQ_J8GJSUc1vZU7a.qGNQXn4VykqVpKoKT53xG4
 sWFwnErHiYDhA6rWzYQVhCO9vg4tPaHBdATQNiNbyoDjIubD0S.YW7V.oZiY
 qGM.XUUEpPnNl_a5UgxH55M3hvsWTRUVlpN0ZSfwYKs3DoP9Hf413ktsXWWu
 yVQpwiPsf8vJDrFydGoQCaflKHZisrOsBF6GTt_SbM1oABfWbUqpbEWnXAts
 CoI9JObO3tFq4gRbxztJsbLHsVWEe9dkPlmdqpGLddBo5mjc2PimF2sMZaZA
 QcrG8hE1zGswhUlmsYo30Gw.vB.WUUXf_YOMlQe172PDINxuENb_P7Odv4zl
 u
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 18 May 2012 10:37:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Rik van Riel <riel@redhat.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
In-Reply-To: <1337355223.573.66.camel@twins>
Message-ID: <alpine.DEB.2.00.1205181036380.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org> <4FB66756.2060302@redhat.com> <alpine.DEB.2.00.1205181022470.21093@router.home> <1337355223.573.66.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Peter Zijlstra wrote:

> Most of that is due to existing interfaces, I'm afraid we cannot
> simplify without reducing those :/

I think some change to those would also be appropriate. Those have grown
over a long time and there are some areas of problematic integration with
the scheduler, numa policies and cpusets etc.

