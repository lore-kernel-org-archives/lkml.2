Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0KXDLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:11:31 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:31133 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751998Ab0KXDLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:11:30 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: YwxHNOwVM1mQiSjNmTqCO.BayljeD_fCaNHxwhZlpQRwH3a
 YQzCGmqFzxa5SeNTE5QTWGEYLnUhBNKcBX3C8HBsMedDFOj2ubQXG4LlPEXE
 LND3YSE4gzGKYynq7L0vMopJRpVkJAlHiTh8G8mYWhmf.ZhyuoeMljEaErtF
 2CbEKWrVESTZrS7Wxaj1II0CvkrLUFipFpat5nWmh6ZrzqmJNVd1EsLYwsL9
 LY5hcgS3fZn4rZXwm.QbFlDGQjh1_3fmigwzcop0-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 23 Nov 2010 21:11:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 09/10] x86: this_cpu_cmpxchg and
 this_cpu_cmpxchg_double operations
In-Reply-To: <1290559301.2866.129.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011232110540.7446@router.home>
References: <20101123235139.908255844@linux.com>  <20101123235201.146063796@linux.com> <1290559301.2866.129.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Eric Dumazet wrote:

> I thought some x86_64 cpus dont have cmpxchg16b ?

Right I vaguely remember a flag there.

> You have to check cx16 feature flag or implement a fallback ?

There is already a compile time fallback. Uhh.. How do I do this at
runtime?

