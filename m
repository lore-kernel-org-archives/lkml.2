Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1BAE4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 23:56:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40832
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815Ab1BAE4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 23:56:30 -0500
Date: Mon, 31 Jan 2011 20:57:05 -0800 (PST)
Message-Id: <20110131.205705.59690433.davem@davemloft.net>
To: weil@mail.berlios.de
Cc: eric.dumazet@gmail.com, tj@kernel.org, jpirko@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] enc28j60: Fix reading of transmit status vector
From: David Miller <davem@davemloft.net>
In-Reply-To: <1296253519-7580-1-git-send-email-weil@mail.berlios.de>
References: <1296253519-7580-1-git-send-email-weil@mail.berlios.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weil <weil@mail.berlios.de>
Date: Fri, 28 Jan 2011 23:25:19 +0100

> This error was reported by cppcheck:
> drivers/net/enc28j60.c:815: error: Using sizeof for array given as function argument returns the size of pointer.
> 
> The original code reads 4 or 8 bytes instead of TSV_SIZE (= 100) bytes.
> I just fixed the code, but did not run any tests.
> 
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>

Applied, thanks.
