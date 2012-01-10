Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2AJQtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:49:16 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:26964 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932114Ab2AJQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:49:15 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zjwXVJYVM1kRHBz2kP7maXAFadLWQWlU_lfqOTb4uSCrdXb
 M0yY9aio9b9GG_zfk84Iry.AAm24YWkSNl0Xct78DxLAC51HPpuj.iwnIY6L
 Q._Jt_rvKKrheVoWs20KhC2U2HYGa7S3_CrcHI95PM7gfp6oMoKEGN5x0VEC
 zHxX.TonRpQEPSFhP67ut1fvKT4DfDsJym3yJdQpL2vFY3XoQTol7E1Qq.QO
 1NnAQD2UzXrpVx._89.viQEta50v1Ch5ZdADd5G4wo5O0vikjTAWajIi7jPo
 NH1uk.t7incQM3AiGYpM8eDQ79Tz4Yje_ke.p6p9_zSVmUNrw2k5mWyHpEW3
 FV26MIEl52L.Ue.H_fA_6asNIofIO0guX82t1Abs17MY5
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 10 Jan 2012 10:49:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch slab/urgent] disallow changing cpu_partial from userspace
 for debug caches
In-Reply-To: <alpine.DEB.2.00.1201091316390.10232@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1201101048440.32577@router.home>
References: <alpine.DEB.2.00.1111230923260.16544@router.home>  <alpine.LFD.2.02.1112120915030.2555@tux.localdomain>  <alpine.DEB.2.00.1112141908410.27595@chino.kir.corp.google.com>  <alpine.DEB.2.00.1201060934550.10460@chino.kir.corp.google.com>
 <1326020041.32105.3.camel@jaguar> <alpine.DEB.2.00.1201090855530.29109@router.home> <alpine.DEB.2.00.1201091316390.10232@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012, David Rientjes wrote:

> This patch disallows tuning /sys/kernel/slab/cache/cpu_partial to be non-
> zero for caches with debugging enabled.

Acked-by: Christoph Lameter <cl@linux.com>

