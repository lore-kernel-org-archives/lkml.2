Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1ELVb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:31:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44181 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790Ab1ELVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:31:26 -0400
Date: Thu, 12 May 2011 17:31:20 -0400 (EDT)
Message-Id: <20110512.173120.932882171086986589.davem@davemloft.net>
To: joe@perches.com
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sctp: sctp_sendmsg: Don't test known non-null sinfo
From: David Miller <davem@davemloft.net>
In-Reply-To: <b6372a0ac574e3fd110de57eb3e41d97c73d5423.1305227621.git.joe@perches.com>
References: <cover.1305227620.git.joe@perches.com>
	<b6372a0ac574e3fd110de57eb3e41d97c73d5423.1305227621.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 14:31:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 May 2011 12:19:10 -0700

> It's already known non-null above.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
