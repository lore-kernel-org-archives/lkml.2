Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0GWQT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:19:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19692 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0GWQTz (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 23 Jul 2010 12:19:55 -0400
Date: Fri, 23 Jul 2010 12:18:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, JBottomley@novell.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/2] remove dma_is_consistent API
Message-ID: <20100723161857.GA10447@phenom.dumpdata.com>
References: <1279798811-21304-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1279798811-21304-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279798811-21304-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C49C120.0048:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 08:40:11PM +0900, FUJITA Tomonori wrote:
> Architectures implement dma_is_consistent() in different ways (some
> misinterpret the definition of API in DMA-API.txt). So it hasn't been
> so useful for drivers. We have only one user of the API in
> tree. Unlikely out-of-tree drivers use the API.
> 
> Even if we fix dma_is_consistent() in some architectures, it doesn't
> look useful at all. It was invented long ago for some old systems that
> can't allocate coherent memory at all. It's better to export only APIs
> that are definitely necessary for drivers.
> 
> Let's remove this API.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
