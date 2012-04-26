Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2DZJFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:05:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58036 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab2DZJFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:05:47 -0400
Date: Thu, 26 Apr 2012 05:05:42 -0400 (EDT)
Message-Id: <20120426.050542.243663587525305831.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH 00/10] atl1c: update hardware settings - v3
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335421638-16304-1-git-send-email-xiong@qca.qualcomm.com>
References: <1335421638-16304-1-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Apr 2012 02:05:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiong <xiong@qca.qualcomm.com>
Date: Thu, 26 Apr 2012 14:27:08 +0800

> This update contains a serial of patches, most of them are hardware
> settings related. register definitions are refined (or removed if
> meaningless) for each patch.
> 
> This is the third serial patches, after reviewed/applied the fourth
> serial will be out.
> 
> The patches have addressed all sparse and checkpatch warnings.
> 
> Following NICs are tested:
> AR8131/AR8132/AR8151A/AR8152A/AR8152B
> Test item includes:
> build/install/uninstall/dhcp/ping/iperf/wol/reboot/etc.

I've applied patches #1 until #9, patch #10 needs to be done
differently.

The PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG bit should be set via a PCI
quirk entry in drivers/pci/quirks.c just as it is done for other
devices which have this problem.

Thank you.
