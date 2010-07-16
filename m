Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936079Ab0GPJBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:01:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49029 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936026Ab0GPJBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:01:47 -0400
Message-ID: <4C401FF2.6090309@cs.helsinki.fi>
Date: Fri, 16 Jul 2010 12:01:38 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kmemleak: Add support for NO_BOOTMEM configurations
References: <20100715145834.20885.20341.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100715145834.20885.20341.stgit@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
> friends use the early_res functions for memory management when
> NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
> corresponding code paths for bootmem allocations.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: H. Peter Anvin <hpa@zytor.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
