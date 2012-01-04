Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2ADXFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:05:43 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48106 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217Ab2ADXFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:05:04 -0500
X-Sasl-enc: oZu0y3f4NwjemgKKDhdLRJAVw7Bmd6/bEZ1wYa2bonCk 1325718303
Date: Wed, 4 Jan 2012 14:52:31 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the s5p
 tree
Message-ID: <20120104225231.GB24583@kroah.com>
References: <20111228160045.21ef706d279fef338ac5d7e0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228160045.21ef706d279fef338ac5d7e0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 04:00:45PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/mach-exynos/cpu.c between commit f983575aa90c ("ARM: EXYNOS:
> Enable conversion of GIC dt irq specifier to linux virq") from the s5p
> tree and commit 4a858cfc9af8 ("arm: convert sysdev_class to a regular
> subsystem") from the driver-core tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks fine, thanks.

greg k-h
