Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab1C3NcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:32:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:43211 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab1C3NcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:32:16 -0400
Date: Wed, 30 Mar 2011 15:32:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Lennert Buytenhek <buytenh@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] powerpc: rename get_irq_desc_data and
 get_irq_desc_chip
In-Reply-To: <20110330132504.GA31832@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1103301531200.22418@localhost6.localdomain6>
References: <20110330132504.GA31832@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Richard Cochran wrote:

> These two functions disappeared in commit
> 
>     0c6f8a8b917ad361319c8ace3e9f28e69bfdb4c1
>     "genirq: Remove compat code"
> 
> but they still exist in qe_ic.h.
> This patch renames the function to their new names.

oops. I really need to figure out to teach coccinelle not to ignore
header files.
 
