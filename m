Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1C2X4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:56:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab1C2X4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:56:31 -0400
Date: Tue, 29 Mar 2011 16:56:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bitmap, irq: Add smp_affinity_list interface to
 /proc/irq
Message-Id: <20110329165612.bd6ad7e4.akpm@linux-foundation.org>
In-Reply-To: <4D926F6C.8010705@sgi.com>
References: <4D926F6C.8010705@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 16:46:52 -0700
Mike Travis <travis@sgi.com> wrote:

> +	/* create /proc/irq/<irq>/smp_affinity_list */
> +	proc_create_data("smp_affinity_list", 0600, desc->dir,
> +			 &irq_affinity_list_proc_fops, (void *)(long)irq);

Always document your interfaces, please.  `grep -r smp_affinity
Documentation' shows where.

And one we've seen a description of the proposed new interface, we can
review the patch!
