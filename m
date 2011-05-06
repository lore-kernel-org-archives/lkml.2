Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1EFMah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:30:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:43981 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab1EFMag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:30:36 -0400
Date: Fri, 6 May 2011 21:30:03 +0900
To: mcree@orcon.net.nz
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        mattst88@gmail.com, rth@twiddle.net, ink@jurassic.park.msu.ru
Subject: Re: [PATCH] alpha: Add DMA_ERROR_CODE defn to avert compiler error
 in drm
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1304496817-7646-1-git-send-email-mcree@orcon.net.nz>
References: <1304496817-7646-1-git-send-email-mcree@orcon.net.nz>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110506212708I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 May 2011 21:30:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 May 2011 20:13:37 +1200
Michael Cree <mcree@orcon.net.nz> wrote:

> The radeon drm code now relies on DMA_ERROR_CODE.  This defines
> it in alpha dma-mapping header to at least enable me to compile
> radeon drm/kms into kernel.
> 
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
>  arch/alpha/include/asm/dma-mapping.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

This isn't correct. The drivers should not use DMA_ERROR_CODE directly
(some architecture specific drivers use it though). Fix rademon
drm/kms instead.
