Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab2GKWTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:19:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:35623 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab2GKWTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:19:21 -0400
Date: Thu, 12 Jul 2012 00:19:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dong Aisheng <b29396@freescale.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, benh@kernel.crashing.org
Subject: Re: [RFC PATCH 2/2] irq: add irq_desc_initialize to remove some
 duplicated lines
In-Reply-To: <1340182831-10477-2-git-send-email-b29396@freescale.com>
Message-ID: <alpine.LFD.2.02.1207120017590.32033@ionos>
References: <1340182831-10477-1-git-send-email-b29396@freescale.com> <1340182831-10477-2-git-send-email-b29396@freescale.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> There're two copies of irq_desc initialization code, reform them into
> an irq_desc_initialize function to call.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  kernel/irq/irqdesc.c |   51 +++++++++++++++++++++++++++----------------------
>  1 files changed, 28 insertions(+), 23 deletions(-)

We add more code by removing redundant copies?

