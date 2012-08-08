Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab2HHXHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:07:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47582 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab2HHXHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:07:05 -0400
Date: Wed, 08 Aug 2012 16:07:04 -0700 (PDT)
Message-Id: <20120808.160704.588005225667606586.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] net/core: Fix potential memory leak in dev_set_alias()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344422005-21993-1-git-send-email-khoroshilov@ispras.ru>
References: <1344422005-21993-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Wed,  8 Aug 2012 14:33:25 +0400

> Do not leak memory by updating pointer with potentially NULL realloc return value.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied, thanks.
