Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2KRVSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 16:18:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52542 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2KRVSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 16:18:36 -0500
Date: Sun, 18 Nov 2012 16:18:33 -0500 (EST)
Message-Id: <20121118.161833.985081954687473276.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121118210253.GI16916@ZenIV.linux.org.uk>
References: <20121118.140332.1273544560009594278.davem@davemloft.net>
	<20121118195921.GH16916@ZenIV.linux.org.uk>
	<20121118210253.GI16916@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 18 Nov 2012 21:02:53 +0000

> Are you OK with the patch below?  Should be the minimal fix, getting
> rid of those segfaults and converting to usual semantics here...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Yep, looks fine:

Acked-by: David S. Miller <davem@davemloft.net>
