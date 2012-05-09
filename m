Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab2EIOOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:14:14 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:21770 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751842Ab2EIOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:14:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ht.9GpcVM1kX4r1vas0HNoocPsetLpgGkDPX8xYHrKtYBWn
 Mx9_ZYEyfWZMjbBS9ewDzxPtOquODU4iKrhNX2db5PD6AkESZhbcwTz.PCnx
 Vy6rrUp9lCkjgXlSTbEuWNhqIB.1o_g6dEA94CoBTP7j9u9OMS778Y.LgSwr
 6kbGDdD3JwTWZr_mZX5L671GlUR7ZDAycXLfYjFDQZLVfa2XEsdIBCpebXCR
 WvUjN4FyrUMyAK26q2y1UfSJgczWXiZp8JDCTVuo7VDNyoccqi7cgN0Qeitt
 EbUNkwUMOxB1itG4oze1Is9.n12_m9cNXQ6O8kMkrLYsOxeFzbX3Zyiu44oA
 HsM7MDCqMvEpPHMYJfNcJxc3C0egP3qelpnyQFUTgy0860QhFpwhVUmGGXMA
 bALWcu4BaM5vCmM.8WJa9IfDrHRZgnm5DbUAU
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 May 2012 09:14:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG at mm/slub.c:374
In-Reply-To: <CAFLxGvy0PHZHVL9rZx_0oFGobKftPBc0EN3VEyzNqvg13FUEfw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205090907070.8171@router.home>
References: <CAFLxGvy0PHZHVL9rZx_0oFGobKftPBc0EN3VEyzNqvg13FUEfw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, richard -rw- weinberger wrote:

> A few minutes ago I saw this BUG within one of my KVM machines.
> Config is attached.

Interrupts on in __cmpxchg_double_slab called from __slab_alloc? Does KVM
do some tricks with interrupt flags? I do not see how that can be
otherwise since __slab_alloc disables interrupts on entry and reenables on
exit.

