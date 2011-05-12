Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab1ELVba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:31:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44184 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab1ELVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:31:28 -0400
Date: Thu, 12 May 2011 17:31:12 -0400 (EDT)
Message-Id: <20110512.173112.1134946518914800656.davem@davemloft.net>
To: joe@perches.com
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] sctp: sctp_sendmsg: Don't initialize
 default_sinfo
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305235641.6124.64.camel@Joe-Laptop>
References: <a4e846ed62d7f9222dc9b09ca00b5356a1eb9b73.1305227620.git.joe@perches.com>
	<20110512.170603.549349521517995900.davem@davemloft.net>
	<1305235641.6124.64.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 14:31:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 May 2011 14:27:20 -0700

> This variable only needs initialization when cmsgs.info
> is NULL.
> 
> Use memset to ensure padding is also zeroed so
> kernel doesn't leak any data.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This looks a lot better, applied.
