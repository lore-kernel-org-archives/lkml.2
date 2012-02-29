Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab2B2Bxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 20:53:53 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51693 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2B2Bxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 20:53:52 -0500
Date: Tue, 28 Feb 2012 20:53:47 -0500 (EST)
Message-Id: <20120228.205347.1718771650331094141.davem@davemloft.net>
To: rodrigue@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@frijolero.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com,
        kgiori@qca.qualcomm.com, chris.snook@gmail.com,
        mathieu@qca.qualcomm.com, bryanh@quicinc.com
Subject: Re: [PATCH] net: add QCA alx Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330480210-30470-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330480210-30470-1-git-send-email-rodrigue@qca.qualcomm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 17:53:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 28 Feb 2012 17:50:09 -0800

> The next patch adds the new QCA alx Ethernet driver that
> supercedes the atl1c Ethernet driver. For details please
> read the commit log of the patch. Given the size you can
> download the patch from:

What's wrong with making evolutionary fixes to atl1c instead
of replacing it wholesale?

This isn't the way to do it Luis.
