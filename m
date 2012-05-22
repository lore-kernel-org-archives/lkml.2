Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab2EVS7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:59:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49890 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab2EVS7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:59:47 -0400
Date: Tue, 22 May 2012 14:57:26 -0400 (EDT)
Message-Id: <20120522.145726.979935187891590882.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@freescale.com, david.daney@cavium.com
Subject: Re: [PATCH 0/5] netdev/phy: 10G PHY support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337709592-23347-1-git-send-email-ddaney.cavm@gmail.com>
References: <1337709592-23347-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 May 2012 11:57:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As mentioned the other day in my announement, right now it is
inappropriate to submit new feature patches.

You will need to resend these changes when the net-next tree opens
back up, please monitor the netdev list to learn when that has
happened.
