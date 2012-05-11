Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946246Ab2EKVaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:30:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36799 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946229Ab2EKVaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:30:13 -0400
Date: Fri, 11 May 2012 17:24:55 -0400 (EDT)
Message-Id: <20120511.172455.120522633866860614.davem@davemloft.net>
To: bjorn@mork.no
Cc: paul.gortmaker@windriver.com, rdunlap@xenotime.net, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        david.daney@cavium.com
Subject: Re: [PATCH] net: of/phy: fix build error when phylib is built as a
 module
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336751221-19127-1-git-send-email-bjorn@mork.no>
References: <20120510.224352.2149006669429730060.davem@davemloft.net>
	<1336751221-19127-1-git-send-email-bjorn@mork.no>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 May 2012 14:24:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Fri, 11 May 2012 17:47:01 +0200

> Should be wrapped into commit 25106022 if it works, to ensure
> bisectability.

Wrapped into?

Commits made to my net-next tree are permanent and irreversible, so we
cannot go back and change a commit.  I never rebase my tree, too many
people use it directly and pull it into their tree, so I'd break their
world if I ever did that.

