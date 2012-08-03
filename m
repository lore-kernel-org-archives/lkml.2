Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2HCRyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:54:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:8959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab2HCRyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:54:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="175332813"
From: Andi Kleen <andi@firstfloor.org>
To: Vikram Pandita <vikram.pandita@ti.com>
Cc: <gregkh@linuxfoundation.org>, <kay@vrfy.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Subject: Re: [PATCH v3] printk: add option to print cpu id
References: <1344013004-32211-1-git-send-email-vikram.pandita@ti.com>
Date: Fri, 03 Aug 2012 10:54:27 -0700
In-Reply-To: <1344013004-32211-1-git-send-email-vikram.pandita@ti.com> (Vikram
	Pandita's message of "Fri, 3 Aug 2012 09:56:44 -0700")
Message-ID: <m2628z6euk.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vikram Pandita <vikram.pandita@ti.com> writes:

> From: Vikram Pandita <vikram.pandita@ti.com>
>
> Introduce config option to enable CPU id reporting for printk() calls.

What's wrong with using trace_printk for this? That's much faster
anyways. Generally printk is so slow that it's typically useless for
instrumenting races.

And really: Wasting 1/3 of the 80 character line is too much.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
