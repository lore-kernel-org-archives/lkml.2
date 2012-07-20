Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab2GTSXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:23:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54552 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2GTSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:23:17 -0400
Date: Fri, 20 Jul 2012 11:23:13 -0700 (PDT)
Message-Id: <20120720.112313.1153363658413977902.davem@davemloft.net>
To: cjren@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH] atl1c: fix issue of io access mode for AR8152 v2.1
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342753318-4507-1-git-send-email-cjren@qca.qualcomm.com>
References: <1342753318-4507-1-git-send-email-cjren@qca.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <cjren@qca.qualcomm.com>
Date: Fri, 20 Jul 2012 11:01:58 +0800

> When io access mode is enabled by BOOTROM or BIOS for AR8152 v2.1,
> the register can't be read/write by memory access mode.
> Clearing Bit 8  of Register 0x21c could fixed the issue.
> 
> Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: xiong <xiong@qca.qualcomm.com>

Applied.

