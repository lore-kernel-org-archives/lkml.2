Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2DKJQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:16:13 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44073 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2DKJQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:16:10 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] iqrdomain: Improve formatting in debugfs.
References: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com>
	<20120411070332.6F3C03E081E@localhost>
X-Yow: Why is it that when you DIE, you can't take your
 HOME ENTERTAINMENT CENTER with you??
Date: Wed, 11 Apr 2012 11:16:06 +0200
In-Reply-To: <20120411070332.6F3C03E081E@localhost> (Grant Likely's message of
	"Wed, 11 Apr 2012 01:03:32 -0600")
Message-ID: <m21unuoch5.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

> @@ -667,7 +667,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
>  			seq_printf(m, "%-15s  ", p);
>  
>  			data = irq_desc_get_chip_data(desc);
> -			seq_printf(m, "0x%16p  ", data);
> +			seq_printf(m, data ? "0x%p  " : "  %p  ", data);

You should be able to use %#p instead to let it add the prefix.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
