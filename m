Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1HMGWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:22:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33503 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1HMGWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:22:42 -0400
Date: Fri, 12 Aug 2011 23:22:35 -0700 (PDT)
Message-Id: <20110812.232235.905351953818584023.davem@davemloft.net>
To: justinmattock@gmail.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10]drivers:atm Remove pointless "@" from various
 parts of the kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313195235-4522-4-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
	<1313195235-4522-4-git-send-email-justinmattock@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 12 Aug 2011 23:22:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>
Date: Fri, 12 Aug 2011 17:27:09 -0700

> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The patch series below removes some pointless "@"'s in various parts of the kernel.
> Note: some might be useful, but then again, some just seemed a waste of space.
> (and since the kernel is become bloated, might as well diet! even if it's a few bits)
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

These are like "XXX" markers in comments, used so you can quickly look
for areas that knowingly need improvement in the code.

I really think these patches are a waste of time and make things worse
not better, the side effect of your patch is that we'll be losing
information.
