Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1KAXeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:34:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38397 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1KAXeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:34:14 -0400
Date: Tue, 01 Nov 2011 19:33:05 -0400 (EDT)
Message-Id: <20111101.193305.2191680732467562808.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ethernet: Move mac89x0.c from apple to cirrus
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319911741-9977-1-git-send-email-geert@linux-m68k.org>
References: <1319911741-9977-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 01 Nov 2011 16:33:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 29 Oct 2011 20:09:01 +0200

> Macintosh CS89x0 based ethernet cards use a Crystal Semiconductor (Now
> Cirrus Logic) CS89x0 chip, so the mac89x0 driver should be in
> drivers/net/ethernet/cirrus instead of drivers/net/ethernet/apple.
> 
> This also fixes a build problem, as the driver needs a header file from the
> cirrus directory:
> 
> drivers/net/ethernet/apple/mac89x0.c:107:20: error: cs89x0.h: No such file or directory
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks.
