Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab2CZULr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:11:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34124 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab2CZULp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:11:45 -0400
Date: Mon, 26 Mar 2012 16:11:37 -0400 (EDT)
Message-Id: <20120326.161137.1457934065978161789.davem@davemloft.net>
To: consul.kautuk@gmail.com
Cc: paul.gortmaker@windriver.com, mingo@elte.hu, joe@perches.com,
        a.p.zijlstra@chello.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20 v2] sparc/mm/fault_32.c: Port OOM changes to
 do_sparc_fault
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAFPAmTT6pcjzi8WsM+r3izreGiuNaK5c4NkDav=6+wFj55QF4Q@mail.gmail.com>
References: <1332698315-2218-1-git-send-email-consul.kautuk@gmail.com>
	<20120325.150422.2000357641354896689.davem@davemloft.net>
	<CAFPAmTT6pcjzi8WsM+r3izreGiuNaK5c4NkDav=6+wFj55QF4Q@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 26 Mar 2012 13:11:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>
Date: Mon, 26 Mar 2012 11:35:56 -0400

> I use gmail which did not show me the indentation which you wanted.
> I understand what you said now and have sent a v3 for this.

No, you don't understand, it's still messed up, in fact you've
made it increasingly worse.
