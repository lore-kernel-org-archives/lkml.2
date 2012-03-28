Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab2C1Vp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:45:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56816 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab2C1Vpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:45:54 -0400
Date: Wed, 28 Mar 2012 17:44:19 -0400 (EDT)
Message-Id: <20120328.174419.1377725053855749758.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: mingo@kernel.org, masami.hiramatsu.pt@hitachi.com,
        prashanth@linux.vnet.ibm.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, acme@infradead.org, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com, rostedt@goodmis.org
Subject: Re: [PATCH] perf: missing export.h file
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332939541.2325.7.camel@edumazet-glaptop>
References: <4F704A1E.2040401@hitachi.com>
	<20120328114745.GA17936@gmail.com>
	<1332939541.2325.7.camel@edumazet-glaptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 14:44:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 28 Mar 2012 14:59:01 +0200

>     CC util/rbtree.o
> ../../lib/rbtree.c:24:26: error: linux/export.h: No such file or
> directory
> cc1: warnings being treated as errors
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> I must be missing something, why nobody hits this error ???

Some don't hit it because it's already installed under /usr/include
