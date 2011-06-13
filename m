Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1FMWeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:34:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45812 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1FMWeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:34:08 -0400
Date: Mon, 13 Jun 2011 18:33:02 -0400 (EDT)
Message-Id: <20110613.183302.2017485603429002993.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: netdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/hplance: hplance_init() should be __devinit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307989056-21814-1-git-send-email-geert@linux-m68k.org>
References: <1307989056-21814-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 13 Jun 2011 15:33:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 13 Jun 2011 20:17:36 +0200

> WARNING: vmlinux.o(.devinit.text+0x253e): Section mismatch in reference from the function hplance_init_one() to the function .init.text:hplance_init()
> 
> The forward declaration had the correct attribute, but the actual function
> definition hadn't.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks.
