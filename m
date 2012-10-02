Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2JBSqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:46:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49915 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab2JBSqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:46:05 -0400
Date: Tue, 02 Oct 2012 14:46:03 -0400 (EDT)
Message-Id: <20121002.144603.513292881191877964.davem@davemloft.net>
To: matthew@walster.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ethernet: clean out braces / old code (found
 via checkpatch)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349178105-28269-2-git-send-email-matthew@walster.org>
References: <1349178105-28269-1-git-send-email-matthew@walster.org>
	<1349178105-28269-2-git-send-email-matthew@walster.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matthew@walster.org
Date: Tue,  2 Oct 2012 12:41:44 +0100

> From: Matthew Walster <matthew@walster.org>
> 
> Remove an old commented out piece of code.
> Remove an if(true) statement.
> Remove a set of braces that weren't strictly necessary.
> 
> All found by running checkpatch.pl against the code.
> 
> Signed-off-by: Matthew Walster <matthew@walster.org>

That comment and that unconditional if() are documentation.

Don't be an automaton and blindly make changes based upon
checkpatch.pl output.
