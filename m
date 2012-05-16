Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2EPTAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:00:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52449 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab2EPTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:00:10 -0400
Date: Wed, 16 May 2012 14:58:58 -0400 (EDT)
Message-Id: <20120516.145858.1919303793301011436.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: tshimizu818@gmail.com, richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp_pch: Add missing #include <linux/slab.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337169017-15835-1-git-send-email-geert@linux-m68k.org>
References: <1337169017-15835-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 16 May 2012 11:59:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 16 May 2012 13:50:17 +0200

> drivers/ptp/ptp_pch.c: In function 'pch_remove':
> drivers/ptp/ptp_pch.c:576:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
> drivers/ptp/ptp_pch.c: In function 'pch_probe':
> drivers/ptp/ptp_pch.c:587:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
