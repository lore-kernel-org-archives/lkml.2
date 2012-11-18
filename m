Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2KRUtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 15:49:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52363 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2KRUtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 15:49:01 -0500
Date: Sun, 18 Nov 2012 15:48:59 -0500 (EST)
Message-Id: <20121118.154859.1718147766545116556.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121118195921.GH16916@ZenIV.linux.org.uk>
References: <CA+55aFxncW2pEhsjg0AO9YKyvPaHyiXZMjoJZ1J8gA+8sH7HNw@mail.gmail.com>
	<20121118.140332.1273544560009594278.davem@davemloft.net>
	<20121118195921.GH16916@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 18 Nov 2012 19:59:21 +0000

> Might be a good idea to start adding tests/* in the kernel tree,
> perhaps?

I've always been a strong advocate of this idea.

I think if someone just did the work to get things going, it would
just pick up it's own momentum and get merged quite easily.
