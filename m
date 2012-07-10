Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2GJQxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:53:53 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35314 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab2GJQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:53:51 -0400
X-Greylist: delayed 1185 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2012 12:53:51 EDT
Date: Wed, 11 Jul 2012 01:33:29 +0900 (JST)
Message-Id: <20120711.013329.1305564732068171297.fujita.tomonori@lab.ntt.co.jp>
To: konrad.wilk@oracle.com
Cc: shuah.khan@hp.com, linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com
Subject: Re: [PATCH RFC] swiotlb: Remove SWIOTLB overflow buffer support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20120709202505.GA9541@phenom.dumpdata.com>
References: <1341615972.3101.27.camel@lorien2>
	<20120709202505.GA9541@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012 16:25:05 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Fri, Jul 06, 2012 at 05:06:12PM -0600, Shuah Khan wrote:
>> Remove SWIOTLB overflow buffer support and return DMA_ERROR_CODE
>> (a value of zero) to make it consistent with iommu implementation
>> on Intel, AMD, and swiotlb-xen.
> 
> While this is a good forward step and this needs to be done eventually,
> you should first send out patches for the drivers that don't check
> for the DMA_ERROR_CODE when doing mapping. In other words for the
> drivers that map but don't call dma_mapping_error to check.
> 
> When that is fixed and *all the drivers that don't call dma_mapping_error
> are fixed, then this patch makes sense. 
> 
> So for right now, NACK.

Yeah, I'm not sure we could fix (or remove) *all the drivers though.
