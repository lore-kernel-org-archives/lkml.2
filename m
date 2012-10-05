Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2JEIQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:16:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2JEIQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:16:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 04/12] video: exynos: warnings in exynos_dp_core.c
Date: Fri, 5 Oct 2012 08:16:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-5-git-send-email-arnd@arndb.de> <002001cda2cf$b0b69c60$1223d520$%han@samsung.com>
In-Reply-To: <002001cda2cf$b0b69c60$1223d520$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210050816.33122.arnd@arndb.de>
X-Provags-ID: V02:K0:/dpPzVzsJYSI2PPUH6y8rLImpdrj+E9IwsvBz7iQLkr
 SmKvGLAtzLkOZ8I6GlH8GO5CdACYxlLZzcK3opqgfM3f0AE3KL
 mqZYtZgz8ecGhFtBMtqXs6yZDUQQDm4SN374GBmHbyr5H9T1Em
 ZF6E3i9njWqmdGpE9iK/Wil4UMsKeXwvhXom1Fa4a8an858eBw
 SuUyQIwYk3948731NmY8TzEgJk26ZJ5GWO8YlZ8a+bP4VYWbX1
 5MxM5BSE7+ef6ttdWZkDTkCbiYCNJ34yC2fkKCXGz+3hskQamc
 63frTzg59ZbOx+WcFulbU8UlrJ6JaaG2eG7i9RLa5pQByUJra6
 f/R9HikyYDNNOSKXIR24=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2012, Jingoo Han wrote:
> This problem was fixed. So, this patch is not necessary.
> 
> As you mentioned, this problem was introduced by d5c0eed01
> "video: exynos_dp: adjust voltage swing and pre-emphasis
> during Link Training".
> 
> However, this problem was resolved by e75478b "video: exynos_dp:
> replace link_status with link_align to check channel equalization".
> 
> The patch was merged to 'fbdev-next', and will be merged to
> '3.7-rc1', soon. Thank you.

Ok, thanks for letting know. I'll drop my patch then.

	Arnd
