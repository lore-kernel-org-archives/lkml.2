Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab2EKWLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:11:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37168 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946281Ab2EKWJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:09:47 -0400
Date: Fri, 11 May 2012 18:06:56 -0400 (EDT)
Message-Id: <20120511.180656.57416607962439989.davem@davemloft.net>
To: cristian.chilipirea@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.baluta@gmail.com
Subject: Re: [PATCH] Net ipv6: Fixed checkpatch errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336755300-6821-1-git-send-email-cristian.chilipirea@gmail.com>
References: <1336755300-6821-1-git-send-email-cristian.chilipirea@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 May 2012 15:06:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cristian Chilipirea <cristian.chilipirea@gmail.com>
Date: Fri, 11 May 2012 19:55:00 +0300

> Fixed all of ERROR "foo* bar" should be "foo *bar"
> 
> Signed-off-by: Cristian Chilipirea <cristian.chilipirea@gmail.com>

Don't ever do this.

This has already been fixed in my net-next tree since April 1st, which
is more than a month ago.  What this means is that you wrote your
patch against something other than reality and your patch won't apply
at all.

All non-bug-fix networking patches should be against the net-next
tree, doing otherwise is at your own peril.
