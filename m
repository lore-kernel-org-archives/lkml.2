Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab1IINFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:05:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:53798 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab1IINFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:05:00 -0400
Date: Fri, 9 Sep 2011 15:04:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Kuo <rkuo@codeaurora.org>
cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch v3 17/36] Hexagon: Add interrupts
In-Reply-To: <20110909010916.327107063@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1109091502571.2723@ionos>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.327107063@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011, Richard Kuo wrote:

> Removed init_IRQ wrapper and fixed up some comments.

> +int show_interrupts(struct seq_file *p, void *v)

Please use the generic version of show_interrupts.

Otherwise please add:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
