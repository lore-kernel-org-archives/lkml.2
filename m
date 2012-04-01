Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2DAULL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:11:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2DAULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:11:09 -0400
Date: Sun, 01 Apr 2012 16:11:04 -0400 (EDT)
Message-Id: <20120401.161104.1115073131193072280.davem@davemloft.net>
To: LinoSanfilippo@gmx.de
Cc: shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: dont overwrite settings for PHY Quick link
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120330172859.GB2703@Neptun>
References: <20120330172859.GB2703@Neptun>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 01 Apr 2012 13:11:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Date: Fri, 30 Mar 2012 19:28:59 +0200

> This patch corrects a bug in function sky2_open() of the Marvell Yukon 2 driver
> in which the settings for PHY quick link are overwritten.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Stephen, ping?
