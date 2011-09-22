Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1IVWG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:06:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1IVWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:06:57 -0400
Date: Fri, 23 Sep 2011 00:06:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Arvid Brodin <arvid.brodin@enea.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: dma_unmap_single() lacking cache sync on some archs?
In-Reply-To: <4E7A7ED4.7080805@enea.com>
Message-ID: <Pine.LNX.4.64.1109230005130.4190@axis700.grange>
References: <4E7A7ED4.7080805@enea.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:d84Orz5Lq9ds7gYCpTv7jepDmy7jlhenC8wgqkFS+Bj
 d1RbwS8gV7SQ2Wh3JmhN38EpoAyFcdywQhZ/vNI2egXyXRs0IE
 g2gfYgfOY5UW73xrv876w3lGlihHlX7UHq+DAeiWbKjW8y14Hs
 43JarTHynkCTRAL7F22nEHkN+hHwruaHprbJx8iCG2ebYoEXeV
 R/0So+x7jFsTHTMHzoAuqYAffrGA0gxOXynmV5jdiq7wO5hyV0
 QPR9nnRXSHWkFjOuyevEKk4gv3LpcrhNMpfVB+SrHZxfBceTRo
 rvaEDR0cWeFe6R9gL6Wao7IhvKBREEIv+4GfLIixPwJmifbB63
 Md5WFC4b6+RgQXOOgcf8PcYsycOA+gpE3na+3j8qxk0WtpI787
 uQ6jwUXqc2Jbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Arvid Brodin wrote:

> Hi,
> 
> I would expect cache synchronization for DMA_TO_DEVICE and DMA_BIDIRECTIONAL
> when dma_map_single() is called, and for DMA_FROM_DEVICE and DMA_BIDIRECTIONAL
> when dma_unmap_single() is called.
> 
> However, on some architechtures (at least avr32, blackfin, ...), cache
> synchronization only happens when dma_map_single() is called (and then
> irrespective of DMA direction). dma_unmap_single() is a no-op for these archs.
> 
> Isn't this a bug?

You'd get a better chance to reach your audience by cc'ing respective arch 
mailing lists and at least the linux-embedded@vger.kernel.org ML.

Thanks
Guennadi

> (Please CC me in responses.)
> 
> -- 
> Arvid Brodin
> Enea Services Stockholm AB

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
