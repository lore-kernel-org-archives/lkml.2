Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1GJOFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 10:05:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1GJOFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 10:05:42 -0400
Date: Sun, 10 Jul 2011 07:04:22 -0700 (PDT)
Message-Id: <20110710.070422.1594762707835771547.davem@davemloft.net>
To: dbaluta@ixiacom.com
Cc: eric.dumazet@gmail.com, richard.cochran@omicron.at,
        mirq-linux@rere.qmqm.pl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] skbuff: update struct sk_buff members comments
From: David Miller <davem@davemloft.net>
In-Reply-To: <1310173408-7727-1-git-send-email-dbaluta@ixiacom.com>
References: <1310173408-7727-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 10 Jul 2011 07:04:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Baluta <dbaluta@ixiacom.com>
Date: Sat,  9 Jul 2011 04:03:28 +0300

> Rearrange struct sk_buff members comments to follow their
> definition order. Also, add missing comments for ooo_okay
> and dropcount members.
> 
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>

Applied, thanks.
