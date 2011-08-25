Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1HYCrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:47:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48073 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1HYCrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:47:15 -0400
Date: Wed, 24 Aug 2011 19:46:53 -0700 (PDT)
Message-Id: <20110824.194653.634810868160099262.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: linux-kernel@vger.kernel.org, dgoulet@ev0ke.net,
        penguin-kernel@I-love.SAKURA.ne.jp, anton@samba.org, stable@kernel.org
Subject: Re: [PATCH 3.1-rc3/3.0.3] sendmmsg/sendmsg: fix unsafe user
 pointer access
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110824.194525.2193895272175663670.davem@davemloft.net>
References: <20110825023940.GA23683@Krystal>
	<20110824.194525.2193895272175663670.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 24 Aug 2011 19:46:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW, please always post all networking patches to netdev@vger.kernel.org,
this way it gets better review and the patch will also be properly tracked
at:

	http://patchwork.ozlabs.org/netdev/list/

Thanks.


