Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab1FGXII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:08:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48801 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab1FGXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:08:06 -0400
Date: Tue, 07 Jun 2011 16:07:47 -0700 (PDT)
Message-Id: <20110607.160747.1497130458418856130.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: Remove unnecessary semicolons
From: David Miller <davem@davemloft.net>
In-Reply-To: <6249a3b9b6716eb774d4c7958c259e5e2d43d642.1307148187.git.joe@perches.com>
References: <6249a3b9b6716eb774d4c7958c259e5e2d43d642.1307148187.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 07 Jun 2011 16:08:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri,  3 Jun 2011 17:45:23 -0700

> Semicolons are not necessary after switch/while/for/if braces
> so remove them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
