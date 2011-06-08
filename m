Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab1FHRt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:49:29 -0400
Received: from sous-sol.org ([216.99.217.87]:55941 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755571Ab1FHRtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:49:25 -0400
Date: Wed, 8 Jun 2011 10:47:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, David Brown <davidb@codeaurora.org>,
        linux-omap@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] x86: intel-iommu: move to drivers/iommu/
Message-ID: <20110608174734.GF23047@sequoia.sous-sol.org>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
 <1307522062-19273-5-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307522062-19273-5-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen (ohad@wizery.com) wrote:
> +
> +config DMAR
> +	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
> +	depends on PCI_MSI && ACPI && EXPERIMENTAL

You may want to further restrict to x86 and ia64
And I think you'll need to fixup arch/ia64/Kconfig

BTW, I think EXPERIMENTAL can be dropped by now.
