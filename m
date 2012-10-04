Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2JDBr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:47:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35346 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2JDBry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:47:54 -0400
Date: Wed, 03 Oct 2012 21:47:50 -0400 (EDT)
Message-Id: <20121003.214750.2022020970468412510.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, vipul@chelsio.com, jay@chelsio.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121004110615.3fda3c25735284c776106d7d@canb.auug.org.au>
References: <20121004101833.019598b7e474c7b74e67ff20@canb.auug.org.au>
	<20121003.205053.1711360628623711137.davem@davemloft.net>
	<20121004110615.3fda3c25735284c776106d7d@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 4 Oct 2012 11:06:15 +1000

> Actually, for me it is.  I have a script that does the "use yesterday's
> version" for me.  To fix (even a one liner) means bringing up an editor,
> commiting, creating the patch and then recommiting it (an implementation
> detail) and recording that I need to keep (automatically) applying the
> patch in case the maintainer doesn't react quickly.

Ok, fair enough.

I'll try to look into making x86 barf when a vmalloc.h include is
missing.

