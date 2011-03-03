Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab1CCSQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:16:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58219 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab1CCSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:16:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Subject: Re: [PATCH v9 1/1] PRUSS UIO driver support
Date: Thu, 3 Mar 2011 19:15:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        tglx@linutronix.de, sshtylyov@mvista.com, amit.chatterjee@ti.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
References: <1299175677-17859-1-git-send-email-pratheesh@ti.com> <1299175677-17859-2-git-send-email-pratheesh@ti.com>
In-Reply-To: <1299175677-17859-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031915.55825.arnd@arndb.de>
X-Provags-ID: V02:K0:za9aTHCheHikzDHObuGvn6XyZVhyFU7k8CZJcluFHo9
 3uc0PReAU4TlvcWcKxGKK7hrBu7EbcX5iOvtSSTZ+BzsSlgJ9V
 nMpLFUFGBEu1vlPKwnWkvLl3E8ShEK8FUZ69Bm3lUiOraJqORn
 5J+w1Dy021vK4FZeuVnOnjzNnfrkHuzeefcWdWH5V0FXCYjFHB
 IxJzR7Aj7+xpdg1XNywwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 March 2011 19:07:57 Pratheesh Gangadhar wrote:
> +struct uio_pruss_dev {
> +       struct uio_info *info;
> +       struct clk *pruss_clk;
> +       dma_addr_t sram_paddr;
> +       dma_addr_t ddr_paddr;
> +       void __iomem *prussio_vaddr;
> +       void *sram_vaddr;
> +       void *ddr_vaddr;
> +       unsigned int hostirq_start;
> +       unsigned int pintc_base;
> +};
> +
> +struct pruss_priv {
> +       struct uio_pruss_dev *pupdev;
> +};

I cannot see the point of struct pruss_priv, I think it would be better to
just merge the two data structures into one. Everything else looks
good to me now.

	Arnd
