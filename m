Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1EDSvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:51:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1EDSvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:51:45 -0400
Date: Wed, 4 May 2011 14:51:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: Add the necessary dependencies to
 hyperv Kconfig
Message-ID: <20110504185142.GA28458@infradead.org>
References: <1304535105-26892-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304535105-26892-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 11:51:45AM -0700, K. Y. Srinivasan wrote:
>  config HYPERV
>  	tristate "Microsoft Hyper-V client drivers"
> -	depends on X86 && m
> +	depends on X86 && ACPI && PCI && m

I can't see anything preventing this driver from beeing built-in,
so the "depends on m" should probably go away.

