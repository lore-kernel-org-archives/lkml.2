Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2DBWmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:42:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56110 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2DBWmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:42:11 -0400
Date: Mon, 02 Apr 2012 18:42:05 -0400 (EDT)
Message-Id: <20120402.184205.386761801119825958.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: LinoSanfilippo@gmx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: dont overwrite settings for PHY Quick link
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120402153818.40e34c2c@s6510.linuxnetplumber.net>
References: <20120330172859.GB2703@Neptun>
	<20120402153818.40e34c2c@s6510.linuxnetplumber.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 02 Apr 2012 15:42:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 2 Apr 2012 15:38:18 -0700

> On Fri, 30 Mar 2012 19:28:59 +0200
> Lino Sanfilippo <LinoSanfilippo@gmx.de> wrote:
> 
>> This patch corrects a bug in function sky2_open() of the Marvell Yukon 2 driver
>> in which the settings for PHY quick link are overwritten.
>> 
>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
 ...
> Acked-by: Stephen Hemminger <shemminger@vyattta.com>

Applied and queued up for -stable.

> Surprised that gcc did not detect the "or" of uninitialized value.

Especially since it warns for so much crap it shouldn't :-)
