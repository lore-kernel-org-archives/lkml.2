Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2LNSQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:16:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48893 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2LNSQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:16:21 -0500
Date: Fri, 14 Dec 2012 13:16:20 -0500 (EST)
Message-Id: <20121214.131620.98357907245917943.davem@davemloft.net>
To: khlebnikov@openvz.org
Cc: linux-kernel@vger.kernel.org, nikolay@redhat.com, netdev@vger.kernel.org,
        fubar@us.ibm.com, andy@greyhouse.net
Subject: Re: [PATCH 08/12] bonding: do not cancel works in bond_uninit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121214110255.11019.14759.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
	<20121214110255.11019.14759.stgit@zurg>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Fri, 14 Dec 2012 15:02:55 +0400

> Bonding initializes these works in bond_open() and cancels in bond_close(),
> thus in bond_uninit() they are already canceled but may be unitialized yet.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Applied.
