Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2F2LKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:10:05 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:54447 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab2F2LKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:10:03 -0400
Message-ID: <4FED8D03.10507@ladisch.de>
Date: Fri, 29 Jun 2012 13:09:55 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] common: dma-mapping: add support for generic dma_mmap_*
 calls
References: <1339741135-7841-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1339741135-7841-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Szyprowski wrote:
> +++ b/drivers/base/dma-mapping.c
> ...
> +int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
> +		    void *cpu_addr, dma_addr_t dma_addr, size_t size)
> +{
> +	int ret = -ENXIO;
> +	...
> +	if (dma_mmap_from_coherent(dev, vma, cpu_addr, size, &ret))
> +		return ret;

This will return -ENXIO if dma_mmap_from_coherent() succeeds.


Regards,
Clemens
