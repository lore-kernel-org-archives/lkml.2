Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1LFTlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:41:53 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63520 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LFTlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:41:52 -0500
Date: Tue, 6 Dec 2011 14:41:49 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
cc: Cong Wang <amwang@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] highmem: Fix ARM build break due to __kmap_atomic
 rename
In-Reply-To: <1323197426-10815-1-git-send-email-swarren@nvidia.com>
Message-ID: <alpine.LFD.2.02.1112061440050.2357@xanadu.home>
References: <1323197426-10815-1-git-send-email-swarren@nvidia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011, Stephen Warren wrote:

> Git commit 37bfbb9 "highmem: kill all __kmap_atomic()" renamed
> __kmap_atomic to kmap_atomic. However, arch/arm/include/asm/highmem.h
> wasn't updated for that change. This change does so, and fixes the
> ARM build break.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This shows up in next-20111206 at least.

Commit 37bfbb9 doesn't show up in anything which is stable yet.  Would 
be best to ask the original author to fix his branch.


Nicolas
