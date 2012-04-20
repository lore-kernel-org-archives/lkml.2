Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2DTARK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:17:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55422 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2DTARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:17:08 -0400
Date: Thu, 19 Apr 2012 20:17:05 -0400 (EDT)
Message-Id: <20120419.201705.1717095047671342251.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH 00/11] atl1c: update hardware settings - v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334822491-30129-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334822491-30129-1-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 19 Apr 2012 17:17:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiong <xiong@qca.qualcomm.com>
Date: Thu, 19 Apr 2012 16:01:20 +0800

> This update contains a serial of patches, most of them are hardware
> settings related. register definitions are refined (or removed if
> meaningless) for each patch.
> 
> This is the second serial patches, after reviewed/applied the third
> serial will be out.
> 
> The patches have addressed all sparse and checkpatch warnings.
> 
> Following NICs are tested:
> AR8131/AR8132/AR8151A/AR8152A/AR8152B
> Test item includes:
> build/install/uninstall/dhcp/ping/iperf/wol/reboot/etc.

Series applied, thanks.
