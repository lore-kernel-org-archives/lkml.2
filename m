Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2KFRoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 12:44:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58486 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2KFRoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 12:44:19 -0500
Date: Tue, 06 Nov 2012 12:44:15 -0500 (EST)
Message-Id: <20121106.124415.1042816028807879843.davem@davemloft.net>
To: yinghai@kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, jacob.shin@amd.com,
        akpm@linux-foundation.org, stefano.stabellini@eu.citrix.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 41/42] sparc, mm: Remove calling of
 free_all_bootmem_node()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352147263-20383-3-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWUiNqv-fd_4Y79eq+-w6wU34nEwn76+QJ7TWw7uCLaaQ@mail.gmail.com>
	<1352147263-20383-1-git-send-email-yinghai@kernel.org>
	<1352147263-20383-3-git-send-email-yinghai@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Mon,  5 Nov 2012 12:27:42 -0800

> Now NO_BOOTMEM version free_all_bootmem_node() does not really
> do free_bootmem at all, and it only call
> register_page_bootmem_info_node instead.
> 
> That is confusing, try to kill that free_all_bootmem_node().
> 
> Before that, this patch will remove calling of free_all_bootmem_node()
> 
> We add register_page_bootmem_info() to call register_page_bootmem_info_node
> directly.
> 
> Also could use free_all_bootmem() for numa case, and it is just
> the same as free_low_memory_core_early().
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
