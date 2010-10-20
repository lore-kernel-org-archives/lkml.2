Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0JTNrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:47:35 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:29094 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752393Ab0JTNre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:47:34 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: AaTquXoVM1n6aVdmljhCSg1VkYg.xzbWkV3qTSpShDfjMhu
 glymqzfHIpvWwBJtJG08vaWHaau8auGZNYL_Yt2pVAgCErx8Af8S0yXM8oXF
 FJE0LEl.JU84EkVJuQvXsdL22gyCmaTFRhG.v8nM7D9XUf3yvVPyS_R_EW1s
 xUHr7cC0htSiIWd7NSWzciISk4LJ5XXyxFbputb9xMBcvRvM9MiDC.UpwP0j
 5
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 20 Oct 2010 08:47:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
In-Reply-To: <alpine.DEB.2.00.1010191337370.20631@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1010200846130.23134@router.home>
References: <20101005185725.088808842@linux.com> <alpine.DEB.2.00.1010191337370.20631@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, David Rientjes wrote:

> Overall, the results are _much_ better than the vanilla slub allocator
> that I frequently saw ~20% regressions with the TCP_RR netperf benchmark
> on a couple of my machines with larger cpu counts.  However, there still
> is a significant performance degradation compared to slab.

It seems that the memory leak is still present. This likely skews the
results. Thought I had it fixed. Thanks.

