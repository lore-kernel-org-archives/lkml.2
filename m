Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1GUVpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:45:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41827 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1GUVpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:45:32 -0400
Date: Thu, 21 Jul 2011 14:45:16 -0700 (PDT)
Message-Id: <20110721.144516.549074030873550786.davem@davemloft.net>
To: jason.wessel@windriver.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, vapier@gentoo.org
Subject: Re: [PATCH] sparc,kgdbts: fix compile regression with kgdb test
 suite
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311109112-12909-1-git-send-email-jason.wessel@windriver.com>
References: <1311109112-12909-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 21 Jul 2011 14:45:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>
Date: Tue, 19 Jul 2011 15:58:32 -0500

> Commit 63ab25ebbc (kgdbts: unify/generalize gdb breakpoint adjustment)
> introduced a compile regression on sparc.
> 
> kgdbts.c: In function 'check_and_rewind_pc':
> kgdbts.c:307: error: implicit declaration of function 'instruction_pointer_set'
> 
> Simply add the correct macro definition for instruction pointer on the
> Sparc architecture.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Acked-by: David S. Miller <davem@davemloft.net>
