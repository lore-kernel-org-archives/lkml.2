Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1ISDCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:02:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53316 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab1ISDCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:02:05 -0400
Date: Sun, 18 Sep 2011 23:00:56 -0400 (EDT)
Message-Id: <20110918.230056.538257203944383944.davem@davemloft.net>
To: jk@ozlabs.org
Cc: torvalds@linux-foundation.org, david.ward@ll.mit.edu,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1316401043.2768.52.camel@pororo>
References: <20110918.210344.570661374586887894.davem@davemloft.net>
	<CA+55aFyENEpGJmTq55=n0_gDiF6RQmdKw-ts4AdQAFQJ1TkF-Q@mail.gmail.com>
	<1316401043.2768.52.camel@pororo>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 18 Sep 2011 20:00:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>
Date: Mon, 19 Sep 2011 10:57:23 +0800

> I've found the problem, and committed a fix & testcase:
> 
>  http://git.ozlabs.org/?p=patchwork;a=commitdiff;h=4bc2c34d
> 
> That fix has been applied to the patchwork.ozlabs.org instance, and I've
> manually updated the incorrect (ie, username-only) entries in the
> patchwork database.

Thanks a bunch Jeremy!
