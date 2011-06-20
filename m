Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1FTIWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:22:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49805 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1FTIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:22:39 -0400
Date: Mon, 20 Jun 2011 01:22:35 -0700 (PDT)
Message-Id: <20110620.012235.1491245779003024008.davem@davemloft.net>
To: rol@witbe.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at net/ipv4/route.c:1677 ip_rt_bug+0x5a/0x70()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110620094725.3508a4e4@tux.DEF.witbe.net>
References: <20110620094725.3508a4e4@tux.DEF.witbe.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 20 Jun 2011 01:22:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Rolland (ポール・ロラン) <rol@witbe.net>
Date: Mon, 20 Jun 2011 09:47:25 +0200

> I'm getting a series of these warning when I start a 64bit Win7 inside
> VirtualBox in a 64bit 3.0.0-rc3 linux.

Please report networking bugs to netdev@vger.kernel.org

Also, see:

http://marc.info/?l=linux-netdev&m=130841949406760&w=2


