Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2DEXIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:08:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60944 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2DEXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:08:46 -0400
Date: Thu, 05 Apr 2012 19:08:38 -0400 (EDT)
Message-Id: <20120405.190838.33439049975921271.davem@davemloft.net>
To: vfalico@redhat.com
Cc: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] bonding: properly unset current_arp_slave on slave
 link up
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120405134743.GB16870@darkmag.usersys.redhat.com>
References: <20120405134743.GB16870@darkmag.usersys.redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 05 Apr 2012 16:08:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Veaceslav Falico <vfalico@redhat.com>
Date: Thu, 5 Apr 2012 15:47:43 +0200

> When a slave comes up, we're unsetting the current_arp_slave without
> removing active flags from it, which can lead to situations where we have
> more than one slave with active flags in active-backup mode.
> 
> To avoid this situation we must remove the active flags from a slave before
> removing it as a current_arp_slave.
> 
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

Applied, thanks.
