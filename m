Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab1LPQcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:32:01 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:44355 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752019Ab1LPQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:31:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: a7XK4bMVM1kNjZDcKxhdj.dOtKW.mijitqIgu4kJEjWnk4c
 iqqUQVCLBtY.aCorD_dj32EtgT06pUyewQ_1cqZ0LCvNwFOJanebLtpEsSlS
 jaRhPm31cqYfHVRitqe_HIbXSS0Jn0l3JkRsfWONWNvIzBl..lJRuSgCdoTG
 6mz8Bl6hikU2nm7234MrinXUG0VxZQaLKXBMckU7HxtBd9At5mDJhQeZc3.O
 MMYi7j3YG3pptn..gIDNDr79Jq_o3eG8eokl1uXu2tupmNGp.6a.T6MmeYie
 A_W4Yq2pXLnNmle_H3eozM1eoGAhUp3QH_DoGSMnyt.4cqeMA7FskdMto_fW
 xM7fvnriIXzezQJ3zTY8rBNoyP02Gp14fbwwf4HSXGtteHg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 16 Dec 2011 10:31:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, "Alex,Shi" <alex.shi@intel.com>,
        Shaohua Li <shaohua.li@intel.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] slub: prefetch next freelist pointer in slab_alloc()
In-Reply-To: <1324049134.25554.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1112161030270.26651@router.home>
References: <1324049134.25554.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011, Eric Dumazet wrote:

> Recycling a page is a problem, since freelist link chain is hot on
> cpu(s) which freed objects, and possibly very cold on cpu currently
> owning slab.

Good idea. How do the tcp benchmarks look after this?

Looks sane.

Acked-by: Christoph Lameter <cl@linux.com>
