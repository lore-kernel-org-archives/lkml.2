Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2HOP4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:56:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49178 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2HOP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:56:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 29/31] arm64: Miscellaneous header files
Date: Wed, 15 Aug 2012 15:56:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-30-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-30-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151556.46426.arnd@arndb.de>
X-Provags-ID: V02:K0:29Hpi7yWzBYyDwJ1fK8WTJt/gUr2+5hNjds+YWQDg+x
 qULhv8QK2CJnVtiF/QiZyHguE3sXeIm7wQA39hydCnrvU1sEjl
 xRHawen3IcZxQaq5Tj4/MSKPnTZSwtQM0UOERkRH+ChIwNKIgG
 p8biZLbYMFZ09JulGcgmg9viIFyfQ2dwRh2NIBZNapwnivo+G5
 nke/Gbu3tX49cwV5/pWRKjDTpAnnMVz7kGSVJq/4zXwxe0R2kV
 SEqq+KDf/1Rm+tcmKWWmPC6NR72xwec+/IWnlnwZJzRCfjwbez
 IhZaqSiaHBeZL64Vzfoq/4z4ys1dn/jofdZ9878Ur0fArWxNNj
 QfBVx6hU9gCov84nEekI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

> diff --git a/arch/arm64/include/asm/cmpxchg.h b/arch/arm64/include/asm/cmpxchg.h
> new file mode 100644
> index 0000000..dc50de7
> --- /dev/null
> +++ b/arch/arm64/include/asm/cmpxchg.h

> +	default:
> +		__bad_cmpxchg(ptr, size);
> +		oldval = 0;
> +	}

I did not see a definition for __bad_cmpxchg but I may have missed that.
Please make sure that none exists, or just use BUILD_BUG_ON().

	Arnd
