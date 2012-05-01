Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab2EABpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:45:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44848 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab2EABpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:45:32 -0400
Date: Mon, 30 Apr 2012 21:45:29 -0400 (EDT)
Message-Id: <20120430.214529.2122095913227933283.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH 00/10] atl1c: update hardware settings - v4
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335836338-9425-1-git-send-email-xiong@qca.qualcomm.com>
References: <1335836338-9425-1-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Apr 2012 18:45:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiong <xiong@qca.qualcomm.com>
Date: Tue, 1 May 2012 09:38:48 +0800

> This update contains a serial of patches, most of them are hardware
> settings related. register definitions are refined (or removed if
> meaningless) for each patch.
> 
> This is the last patch set.
> 
> The patches have addressed all sparse and checkpatch warnings.
> 
> Following NICs are tested:
> AR8131/AR8132/AR8151A/AR8152A/AR8152B
> Test item includes:
> build/install/uninstall/dhcp/ping/iperf/wol/reboot/etc.

All applied, thanks.
