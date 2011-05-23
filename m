Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1EWGr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:47:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51091 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1EWGrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 02:47:25 -0400
Date: Mon, 23 May 2011 02:46:20 -0400 (EDT)
Message-Id: <20110523.024620.245701157448889932.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org
Subject: Re: [PATCH 4/4] sparc: iounmap() and *_free_coherent() - Use
 lookup_resource()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306006756-32009-5-git-send-email-geert@linux-m68k.org>
References: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
	<1306006756-32009-5-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 May 2011 23:46:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 21 May 2011 21:39:16 +0200

> Replace a custom implementation (which doesn't lock the resource tree) by a
> call to lookup_resource()
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: David S. Miller <davem@davemloft.net>
