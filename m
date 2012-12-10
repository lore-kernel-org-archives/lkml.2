Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2LJUrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:47:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59796 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2LJUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:47:30 -0500
Date: Mon, 10 Dec 2012 15:47:28 -0500 (EST)
Message-Id: <20121210.154728.1064961726249039464.davem@davemloft.net>
To: will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        benh@kernel.crashing.org, arnd@arndb.de, james.hogan@imgtec.com,
        matthew@mattleach.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/10] net: dm9000: use io{read,write}*_rep accessors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1355166762-15133-6-git-send-email-will.deacon@arm.com>
References: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
	<1355166762-15133-6-git-send-email-will.deacon@arm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>
Date: Mon, 10 Dec 2012 19:12:37 +0000

> From: Matthew Leach <matthew@mattleach.net>
> 
> The {read,write}s{b,w,l} operations are not defined by all
> architectures and are being removed from the asm-generic/io.h
> interface.
> 
> This patch replaces the usage of these string functions in the default
> DM9000 accessors with io{read,write}{8,16,32}_rep calls instead. This
> is required as the dm9000 driver is in use by the blackfin
> architecture which uses the asm-generic io accessors.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Matthew Leach <matthew@mattleach.net>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Applied.
