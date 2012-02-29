Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2B2B6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 20:58:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51733 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab2B2B6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 20:58:23 -0500
Date: Tue, 28 Feb 2012 20:58:13 -0500 (EST)
Message-Id: <20120228.205813.1504449700643199024.davem@davemloft.net>
To: rodrigue@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@frijolero.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com,
        kgiori@qca.qualcomm.com, chris.snook@gmail.com,
        mathieu@qca.qualcomm.com, bryanh@quicinc.com,
        steventl@qca.qualcomm.com, hao-ran.liu@canonical.com,
        cjren@qca.qualcomm.com, joe@perches.com
Subject: Re: [PATCH] net: add new QCA alx ethernet driver which supercedes
 atl1c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330480210-30470-2-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330480210-30470-1-git-send-email-rodrigue@qca.qualcomm.com>
	<1330480210-30470-2-git-send-email-rodrigue@qca.qualcomm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 17:58:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 28 Feb 2012 17:50:10 -0800

> QCA is commiting on fixing all bugs upstream on this driver.

By implication QCA is not willing to fix bugs in and properly
maintain the existing in-tree atl1c driver.

We're not going to wholesale replace an entire driver in this
way, and you should know better Luis.

Please research the history of the Broadcom TG3 driver, Jeff Garzik
and myself wrote a driver for Linux ignoring Broadcom's out of tree
driver completely.

Several times Broadcom tried to just plunk their out-of-tree driver,
however properly cleaned up, into the tree.  We considerd that
unacceptable and pushed back until they started instead making gradual
improvements and fixes to the driver Jeff and myself wrote and had in
the tree already.  And they did.

We expect Qualcomm to follow this precedent, and I will push back
strongly on any attempt to just replace the existing driver.
