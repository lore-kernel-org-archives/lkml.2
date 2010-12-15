Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0LOQMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:12:42 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:21190 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751661Ab0LOQMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:12:41 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 136k1DsVM1m1YaBkRz0nraM1sMAOgil.5e3de3JjJf5OcjW
 GetF_mWc0n42n75zC6IXHxjsnxiG0QGAljHmvas0IVxWzJQ6kWuTb._r4msI
 IE8C018x7EEWLCIhbB2LjGONDTF9vsalYJ5WOy.ATamqGDPq_umYpEKNsBcG
 zpHWuj_5Hh.JBYTU1uikE1ZrHo0AtxY7DNptKyNk1z_DUgFaT38.gmnqsL13
 9eQuB_rPPSZ.H4akXRQ_gmXoELuvQ5KVIrn4q75SXpSMksz_UrzgAcws07uw
 FL55kkP0f5UsrHlPf8JzJKD5en5RnMzDlPZcv5MZo7KHoG.oRF_R39_g5D5n
 Yti9BTZ8-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 15 Dec 2010 10:12:37 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 2/4] x86: this_cpu_cmpxchg_double()
 support
In-Reply-To: <4D081225.8000007@zytor.com>
Message-ID: <alpine.DEB.2.00.1012151011550.12186@router.home>
References: <20101214174847.887713690@linux.com> <20101214174900.659284593@linux.com> <4D080FDC.7030005@zytor.com> <4D081225.8000007@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010, H. Peter Anvin wrote:

> > NAK on this.  This is acceptable for cmpxchg8b only because we don't
> > support SMP on 486s anymore.  x86-64 is another matter...
> >
>
> Hm, this is meant to be a CPU local operation, isn't it... it isn't very
> clear from the comments or naming *in this file*.

Ok. But the code is correct as far as I can tell. Its not a global cmpxchg
but local. Interrupt disable is ok.

> Could you make it a little clearer in the local code, please?

ok.

