Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab1IVAXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 20:23:54 -0400
Received: from sestofw01.enea.se ([192.36.1.252]:3145 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750874Ab1IVAXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 20:23:53 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 20:23:53 EDT
Message-ID: <4E7A7ED4.7080805@enea.com>
Date: Thu, 22 Sep 2011 02:18:28 +0200
From: Arvid Brodin <arvid.brodin@enea.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: dma_unmap_single() lacking cache sync on some archs?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.23.1.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would expect cache synchronization for DMA_TO_DEVICE and DMA_BIDIRECTIONAL
when dma_map_single() is called, and for DMA_FROM_DEVICE and DMA_BIDIRECTIONAL
when dma_unmap_single() is called.

However, on some architechtures (at least avr32, blackfin, ...), cache
synchronization only happens when dma_map_single() is called (and then
irrespective of DMA direction). dma_unmap_single() is a no-op for these archs.

Isn't this a bug?

(Please CC me in responses.)

-- 
Arvid Brodin
Enea Services Stockholm AB

