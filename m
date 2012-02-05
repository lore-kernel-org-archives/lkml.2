Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2BEWqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:46:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43963 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab2BEWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:46:47 -0500
Date: Sun, 05 Feb 2012 17:46:23 -0500 (EST)
Message-Id: <20120205.174623.402259480734565793.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, jeffrey.t.kirsher@intel.com,
        steffen.klassert@secunet.com, gregory.v.rose@intel.com,
        paul.gortmaker@windriver.com, SteveW@ACM.org, emserrat@geocities.com
Subject: Re: [PATCH] Net, decnet: remove unused variable from dn_output()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1202052327050.32529@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202052327050.32529@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 05 Feb 2012 14:46:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 5 Feb 2012 23:28:57 +0100 (CET)

> The variable 'neigh' is assigned to, but otherwise completely
> unused. So let's remove it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
