Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1JSHuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:50:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52308 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab1JSHuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:50:02 -0400
Date: Wed, 19 Oct 2011 03:50:00 -0400 (EDT)
Message-Id: <20111019.035000.931404890148181821.davem@davemloft.net>
To: cjren@qca.qualcomm.com
Cc: rodrigue@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <6349D7A510622448B1BA0967850A8438011CBA5D@nasanexd02d.na.qualcomm.com>
References: <1319009213-20627-1-git-send-email-cloud.ren@atheros.com>
	<20111019.033324.1233460304204609569.davem@davemloft.net>
	<6349D7A510622448B1BA0967850A8438011CBA5D@nasanexd02d.na.qualcomm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 00:50:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ren, Cloud" <cjren@qca.qualcomm.com>
Date: Wed, 19 Oct 2011 07:44:02 +0000

> Ok. What logging interfaces can I use? Are they dev_err, dev_info and dev_warn ? thanks

netif_*(), they check netif_msg_*() to see if the particular kind
of logging message is enabled or not, and this can be set dynamically
if you code your driver to properly set netdev->msg_enable.

Use other drivers as examples.

