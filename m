Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1HLGIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:08:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44291 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1HLGIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:08:43 -0400
Date: Thu, 11 Aug 2011 23:06:39 -0700 (PDT)
Message-Id: <20110811.230639.1484435085208010743.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next] spider_net: fix compile issue introduced by driver
 move
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313120000-12085-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1313120000-12085-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 23:06:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 11 Aug 2011 20:33:20 -0700

> Both Spider net driver and Sun GEM driver use the sungem_phy.o object.
> This fix creates a Kconfig object for sungem_phy (like MDIO) so that
> both drivers require the SUNGEM_PHY object.
> 
> This has been compile tested for the Sun GEM driver.
> 
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied, thanks Jeff.
