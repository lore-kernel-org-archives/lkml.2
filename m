Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2DRThP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:37:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40901 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab2DRThN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:37:13 -0400
Date: Wed, 18 Apr 2012 15:37:10 -0400 (EDT)
Message-Id: <20120418.153710.430492542259953028.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH 00/12] atl1c: update hardware settings - v1
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334727156-6830-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334727156-6830-1-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 Apr 2012 12:37:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiong <xiong@qca.qualcomm.com>
Date: Wed, 18 Apr 2012 13:32:24 +0800

> This update contains a serial of patches, most of them are hardware
> settings related. register definitions are refined (or removed if 
> meaningless) for each patch.
> 
> This is the first serial patches, after reviewed/applied the second
> serial will be out.
> 
> These patches have addressed all sparse and checkpatch warnings.
> 
> Following NICs are tested:
> AR8131/AR8132/AR8151A/AR8152A/AR8152B
> Test item includes:
> build/install/uninstall/dhcp/ping/iperf/wol/reboot/etc.

All applied, thanks.
