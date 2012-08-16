Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2HPWLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:11:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35935 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab2HPWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:11:52 -0400
Date: Thu, 16 Aug 2012 15:11:51 -0700 (PDT)
Message-Id: <20120816.151151.1086500546875406230.davem@davemloft.net>
To: john.r.fastabend@intel.com
Cc: viro@ZenIV.linux.org.uk, nhorman@tuxdriver.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v3 2/3] net: netprio: fd passed in SCM_RIGHTS
 datagram not set correctly
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120814223430.3551.88909.stgit@jf-dev1-dcblab>
References: <20120814223424.3551.21608.stgit@jf-dev1-dcblab>
	<20120814223430.3551.88909.stgit@jf-dev1-dcblab>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Fastabend <john.r.fastabend@intel.com>
Date: Tue, 14 Aug 2012 15:34:30 -0700

> A socket fd passed in a SCM_RIGHTS datagram was not getting
> updated with the new tasks cgrp prioidx. This leaves IO on
> the socket tagged with the old tasks priority.
> 
> To fix this add a check in the scm recvmsg path to update the
> sock cgrp prioidx with the new tasks value.
> 
> Thanks to Al Viro for catching this.
> 
> CC: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>

Applied.
