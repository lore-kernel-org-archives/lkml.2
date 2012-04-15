Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2DOQdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 12:33:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37247 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2DOQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 12:33:20 -0400
Date: Sun, 15 Apr 2012 12:33:06 -0400 (EDT)
Message-Id: <20120415.123306.2132770845160354506.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: tim.gardner@canonical.com, linux-kernel@vger.kernel.org, jdmason@kudzu.us,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: vxge: Add MODULE_FIRMWARE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334498215.3209.4.camel@deadeye>
References: <1334262882-96973-1-git-send-email-tim.gardner@canonical.com>
	<1334498215.3209.4.camel@deadeye>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 15 Apr 2012 09:33:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 15 Apr 2012 14:56:55 +0100

> Also: this driver's behaviour of automatically updating flash without
> any confirmation seems quite dangerous.  The driver also isn't usable
> after it performs such an update:
> 
> 	printk(KERN_NOTICE "Upgrade of firmware successful!  Adapter must be "
> 	       "hard reset before using, thus requiring a system reboot or a "
> 	       "hotplug event.\n");
> 
> So what is the point of integrating firmware update into the driver at
> all?

This is beyond terrible.
