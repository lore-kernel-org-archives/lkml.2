Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab1EMVFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:05:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61568 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab1EMVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:05:48 -0400
Date: Fri, 13 May 2011 18:06:20 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 6/9] Bluetooth: Silence DEBUG_STRICT_USER_COPY_CHECKS=y
 warning
Message-ID: <20110513210620.GB2187@joana>
Mail-Followup-To: Stephen Boyd <sboyd@codeaurora.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
 <1305244212-19183-7-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305244212-19183-7-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

* Stephen Boyd <sboyd@codeaurora.org> [2011-05-12 16:50:09 -0700]:

> Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
> warning:
> 
> In function 'copy_from_user',
>     inlined from 'rfcomm_sock_setsockopt' at
>     net/bluetooth/rfcomm/sock.c:705:
> arch/x86/include/asm/uaccess_64.h:65:
> warning: call to 'copy_from_user_overflow' declared with
> attribute warning: copy_from_user() buffer size is not provably
> correct
> 
> presumably due to buf_size being signed causing GCC to fail to
> see that buf_size can't become negative.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Gustavo F. Padovan <padovan@profusion.mobi>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  net/bluetooth/rfcomm/sock.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Applied, thanks.

-- 
Gustavo F. Padovan
http://profusion.mobi
