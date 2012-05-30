Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2E3Cbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 22:31:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33538 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab2E3Cbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 22:31:38 -0400
Date: Tue, 29 May 2012 22:31:30 -0400 (EDT)
Message-Id: <20120529.223130.1732658596355230297.davem@davemloft.net>
To: devendra.aaru@gmail.com
Cc: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] r6040: disable pci device if the subsequent
 calls (after pci_enable_device) fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338334722-14730-1-git-send-email-devendra.aaru@gmail.com>
References: <1338334722-14730-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 May 2012 19:31:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Devendra Naga <devendra.aaru@gmail.com>
Date: Wed, 30 May 2012 05:08:42 +0530

> the calls after the pci_enable_device may fail, and will error out with out
> disabling it. disable the device at error paths.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Applied.
