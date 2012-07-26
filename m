Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab2GZOL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:11:57 -0400
Received: from ozlabs.org ([203.10.76.45]:55987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab2GZOL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:11:56 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: wei_wang@realsil.com.cn, gregkh@linuxfoundation.org,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 2/3] drivers/misc: Add realtek pci card reader driver
In-Reply-To: <1342778966-30270-1-git-send-email-wei_wang@realsil.com.cn>
References: <1342778966-30270-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 26 Jul 2012 22:47:51 +0930
Message-ID: <87pq7ioe4g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012 18:09:26 +0800, <wei_wang@realsil.com.cn> wrote:
> +static int msi_en = 1;
> +module_param(msi_en, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(msi_en, "Enable MSI");

Should this be a bool, and a module_param(msi_en, bool, S_IRUGO | S_IWUSR);?

> +static int adma_mode = 1;
> +module_param(adma_mode, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(adma_mode, "ADMA Mode");

This too?

> +	/* Data transferred in ADMA mode or not */
> +	int			adma_mode;

And this?

Cheers,
Rusty.
