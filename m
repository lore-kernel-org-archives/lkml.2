Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab2HWHNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:13:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34162 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2HWHNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:13:46 -0400
Date: Thu, 23 Aug 2012 00:13:42 -0700 (PDT)
Message-Id: <20120823.001342.959509094678320374.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: cjren@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH v2] net: add new QCA alx ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <157393863283F442885425D2C45428562A4F519A@nasanexd02f.na.qualcomm.com>
References: <157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
	<20120822.234019.1546353507351890178.davem@davemloft.net>
	<157393863283F442885425D2C45428562A4F519A@nasanexd02f.na.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Huang, Xiong" <xiong@qca.qualcomm.com>
Date: Thu, 23 Aug 2012 06:56:51 +0000

> I'm afraid someone also rejects my request to add such operation to
> ethtool

If you don't design it properly, we certainly will ask you to make
changes.

But it stands a chance of actually being accepted, whereas your
debugfs thing absolutely does not.
