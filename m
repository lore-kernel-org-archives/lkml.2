Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1AUSmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:42:38 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:47958 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752993Ab1AUSmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:42:38 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 203v0UcVM1mdlOd8SutWc96OJsPx9uIHfqid2O2o9BI8m2E
 QPKyKCWZs6xzliqn5KK0k3i9lNSuAkew2ZdL.GMHLb4ZxLDupgmu7VQAbHmV
 Py8euUwaOGNMQhYu3E4Wo.nuoxF_dihSwnbkA0qniGMhT6lr9PFSHQnKe7HO
 PCBVehn9eX_Hx6I4PgtQuBF7w2OxIfIgIfCIPM9v5Anm_HTQCBmG79bgddxM
 F5bO336ZAjseSH8t1BdPxihFbNGyc1eq2nH8WhlBCUFbfixaHVSdqKI.St09
 nmAwjfNxPQxvn2W7fG.arrFr1iDglqGYfNEkPyh4s3c6tet0-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 12:42:34 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110121181051.GC12150@Krystal>
Message-ID: <alpine.DEB.2.00.1101211241060.15692@router.home>
References: <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
 <alpine.DEB.2.00.1101211121350.15692@router.home> <20110121174236.GA12150@Krystal> <alpine.DEB.2.00.1101211146320.15692@router.home> <20110121181051.GC12150@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Mathieu Desnoyers wrote:

> "if the pointer passed is constant" -> if you use the actual type of percpu_dd
> to check the alignment, then you can do an alignment check at compile-time even
> for a non-const parameter. The requirement imposed on typing will take care to
> make sure that even a non-const pointer will have the proper alignment.

True that would be a benefit if we used something like percpu_dd. If
somehow we can marry that to a parameter list that only includes single
word entities then we would have the best of both.

