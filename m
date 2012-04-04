Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2DDWq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:46:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50642 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab2DDWq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:46:27 -0400
Date: Wed, 04 Apr 2012 18:45:59 -0400 (EDT)
Message-Id: <20120404.184559.1109693471298332312.davem@davemloft.net>
To: consul.kautuk@gmail.com
Cc: paul.gortmaker@windriver.com, mingo@elte.hu, joe@perches.com,
        a.p.zijlstra@chello.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20 v4] sparc/mm/fault_32.c: Port OOM changes to
 do_sparc_fault
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAFPAmTQNMMVbE_7csGizhYG0LAHe-LbFHTSXZwfanB2K6HaJEw@mail.gmail.com>
References: <1332780474-2881-1-git-send-email-consul.kautuk@gmail.com>
	<20120326.173606.1348576857155624658.davem@davemloft.net>
	<CAFPAmTQNMMVbE_7csGizhYG0LAHe-LbFHTSXZwfanB2K6HaJEw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 15:46:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>
Date: Wed, 4 Apr 2012 20:00:01 +0530

> Since one or two of my other patches are being taken by the other arch
> owners in their branches,
> can you take this patch and apply it to your branch also ?

Both sparc patches applied, thanks.
