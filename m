Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2EUTdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:33:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40492 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2EUTdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:33:14 -0400
Date: Mon, 21 May 2012 15:32:57 -0400 (EDT)
Message-Id: <20120521.153257.724964822171767587.davem@davemloft.net>
To: michael@araneidae.co.uk
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement full reset of DM9000 network device
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1205211344010.26839@venus.araneidae.co.uk>
References: <alpine.DEB.2.00.1205211344010.26839@venus.araneidae.co.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 21 May 2012 12:32:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Abbott <michael@araneidae.co.uk>
Date: Mon, 21 May 2012 13:47:53 +0100 (BST)

> A Davicom application note for the DM9000 network device recommends
> performing software reset twice to correctly initialise the device.
> Without this reset some devices fail to initialise correctly on
> system startup.
> 
> Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>

Please post networking patches to netdev@vger.kernel.org, the networking
developers are not all listening on linux-kernel.

Plus, by properly submitting networking patches to netdev, it will
automatically be queued up and tracked in patchwork:


http://patchwork.ozlabs.org/project/netdev/list/
