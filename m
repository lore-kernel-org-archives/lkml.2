Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2CWTqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:46:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38371 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab2CWTqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:46:22 -0400
Date: Fri, 23 Mar 2012 15:46:18 -0400 (EDT)
Message-Id: <20120323.154618.266106775092146713.davem@davemloft.net>
To: teigland@redhat.com
Cc: swhiteho@redhat.com, rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: GFS2: Pre-pull patch posting (merge window)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120323194152.GD24746@redhat.com>
References: <4F674E4F.5080904@xenotime.net>
	<1332171247.2689.28.camel@menhir>
	<20120323194152.GD24746@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 23 Mar 2012 12:46:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>
Date: Fri, 23 Mar 2012 15:41:52 -0400

> Why does gfs2 Kconfig bother with SCTP at all?  It seems that line should
> just be removed.  I'll also remove EXPERIMENTAL.  I don't understand the
> vagaries of Kconfig, so a dumb question, how could sctp_do_peeloff
> possibly be undefined if we're selecting SCTP.

GFS2=y SCTP=m
