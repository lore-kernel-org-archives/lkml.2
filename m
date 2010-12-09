Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0LIXjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:39:06 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:33279 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756881Ab0LIXjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:39:03 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ET57ej0VM1kr1.w0iLht7IxKm4xEYctrut0MHfnJEQd71lP
 DrAVJQElUIMn9Ti95SS9vsjHi1RghFMGDWugxfa366C0mAijK6eKAynoT6CP
 OrHeaYkHuMxAvZGPAOFzueDHQcPc8m5TjMUAawDeyLLpDot8tW58BnSeXybc
 Ld6YwqkMivDIhXeZAkYAj1YdlnvUIrCCP_p54mteQoSYIGEJ9AjbCSmkWegj
 BgnC4t.Bb5KGNWykAAU8Nh9mvLKjSk.29sDEAtiHN9F6Ap5FqfoZN2ViAZTl
 1Y8vYiW416P6o6k3oVPhKPATZRA0V5MLSY.sczC0OECAGBq8-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 9 Dec 2010 17:38:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] printk: Use this_cpu_{read|write} api on
 printk_pending
In-Reply-To: <1291859019.2795.20.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1012091737240.29367@router.home>
References: <1290788536.2855.237.camel@edumazet-laptop>  <tip-40dc11ffb35e8c4e8fa71092048e0f8de9db758c@git.kernel.org>  <alpine.DEB.2.00.1012081546170.28112@router.home> <1291859019.2795.20.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Eric Dumazet wrote:

> Its a bit strange, I sent mine a long time ago when reviewing Heiko
> Carstens patch. You even commented on it.
>
> https://patchwork.kernel.org/patch/359182/
>
> What happened then, you included my patch on one of yours ?

I just went through the tree and changed all __get_cpu_var. Out came a
single core patch that also covered this earlier case.


