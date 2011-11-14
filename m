Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1KNFcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:32:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49799 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1KNFcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:32:46 -0500
Date: Mon, 14 Nov 2011 00:31:35 -0500 (EST)
Message-Id: <20111114.003135.1573678759988884995.davem@davemloft.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cooldavid@cooldavid.org
Subject: Re: [PATCH V2 3/6] net/ethernet/jme: Disable ASPM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321028064-644-4-git-send-email-mjg@redhat.com>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
	<1321028064-644-4-git-send-email-mjg@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:31:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>
Date: Fri, 11 Nov 2011 11:14:21 -0500

> http://driveragent.com/archive/30421/7-0-14 indicates that ASPM is
> disabled on the 250 and 260. Duplicate for sanity.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Applied.
