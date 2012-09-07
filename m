Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab2IGTiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:38:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2IGTit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:38:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 14/31] arm64: DMA mapping API
Date: Fri, 7 Sep 2012 19:38:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-15-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-15-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071938.44894.arnd@arndb.de>
X-Provags-ID: V02:K0:kjMMo6v4Ua4Z4Am2fcImIQL9fYmhOLjUGQDUjdwjtk/
 hB01h6XR0v/SUhPI9HF/vnlKhvA/wGh7IxJLW77OE/CO2EsJh1
 4zYL7B+wFv3sqjhyWfbYU7tYUE0ndILgJL9kcUemuJYSmzIU73
 X8yJAxbARAbIyfcXM2+TjU2t685WQBWLX3LBt0pkBQ29t9t6Nn
 4rubmYh472LM0ydP2Z9KppGSCZgeOYOLaG3yYD4wwpIIOAyGdg
 ZPBUeRk8sUsk5RGld57R/sG5lKH01XDb1L/WLxG75aW4hkencD
 EK2mcKNNw9+jFjHyUvDLZAbSLh1WwLRr9Hm3nisimAoJH7pWlm
 JfIrIh0/rac/7WGGWQwI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> This patch adds support for the DMA mapping API. It uses dma_map_ops for
> flexibility and it currently supports swiotlb. This patch could be
> simplified further if the DMA accesses are coherent (not mandated by the
> architecture) or if corresponding hooks are placed in the generic
> swiotlb code to deal with cache maintenance.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
