Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab2BJNFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:05:45 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:23092 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2BJNFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:05:43 -0500
Message-ID: <4F351624.6060302@tilera.com>
Date: Fri, 10 Feb 2012 08:05:40 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 59/60] highmem: kill all __kmap_atomic() [swarren@nvidia.com:
 highmem: Fix ARM build break due to __kmap_atomic rename]
References: <1328852421-19678-1-git-send-email-amwang@redhat.com> <1328852421-19678-60-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-60-git-send-email-amwang@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/2012 12:40 AM, Cong Wang wrote:
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
> [...]
>  arch/tile/include/asm/highmem.h      |    2 +-
>  arch/tile/mm/highmem.c               |    4 ++--

For tile,

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

