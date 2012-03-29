Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab2C2S4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:56:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:58639 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917Ab2C2S4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:56:05 -0400
Date: Thu, 29 Mar 2012 20:55:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <liuj97@gmail.com>
cc: Greg KH <greg@kroah.com>, Jiang Liu <jiang.liu@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] IRQ: introduce irq_do_set_affinity() to reduce
 duplicated code
In-Reply-To: <1333039493-4090-1-git-send-email-jiang.liu@huawei.com>
Message-ID: <alpine.LFD.2.02.1203292049400.2542@ionos>
References: <1333039493-4090-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Jiang Liu wrote:

> Introduce irq_do_set_affinity() to reduce duplicated code.
> This patch also fixes a minor bug in irq_move_masked_irq(),
> which treats return value IRQ_SET_MASK_OK_NOCOPY as error.

Again. Please don't do that.

A bug fix is a bug fix and a cleanup is a cleanup. Mixing both is
simply wrong. It's also completely non obvious from the subject line
that this patch contains a bug fix - minor or not is completely
irrelevant.

The order is bug fix first, then cleanup and improvements. 

Please be more careful about this.

Thanks,

	tglx
