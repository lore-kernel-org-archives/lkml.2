Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0LOQlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:41:07 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:31154 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752622Ab0LOQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:41:05 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: A3w0NjkVM1kBu1t0zb5sw2zhz8uwJuX2aOeEtZW8PJCAbma
 5EejtrdRZhGqw3Rfyso8BDY6tHu1xseRju.eJ3YTPeprJvp6OUkqqS4xUHZ9
 adqvN_X86uZaXCBJdWLJWmM5m3m1tongtNOq7DUZJLRVia_BR7lQRxAlHOhj
 9bCp2WIrTakm5MAGJCbWuKGv60wlc4TcSVPRcVusQV47j5LRhr5ud_K5Qrrj
 se9hTe.KmrO5xBMjS4gz7GfEmImUwHj1VHnrvlPYRrMOerylalUJoJxBh9g5
 iKmJpgTb.F_8bIDZ324aljxFBYFqAll_ecer6HURb6Z8rdYo-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 15 Dec 2010 10:41:01 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 2/4] x86: this_cpu_cmpxchg_double()
 support
In-Reply-To: <4D08EDA8.90702@zytor.com>
Message-ID: <alpine.DEB.2.00.1012151040150.12470@router.home>
References: <20101214174847.887713690@linux.com> <20101214174900.659284593@linux.com> <4D080FDC.7030005@zytor.com> <4D081225.8000007@zytor.com> <alpine.DEB.2.00.1012151011550.12186@router.home> <4D08EDA8.90702@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, H. Peter Anvin wrote:

> Yes, that's what I meant... the code is correct, it's just not obvious
> from someone who looks at the code that it is correct, because the
> intended function of the code isn't obvious from that file by itself (in
> fact, it looks almost exactly like the 486 cmpxchg ersatz code.)

Confirmed. It is a copy of that 486 ersatz code ... But its ok for the use
case here.


