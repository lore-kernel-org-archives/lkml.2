Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2C2GMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:12:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59371 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2C2GMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:12:37 -0400
Date: Thu, 29 Mar 2012 08:12:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, masami.hiramatsu.pt@hitachi.com,
        prashanth@linux.vnet.ibm.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, acme@infradead.org, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com, rostedt@goodmis.org
Subject: Re: [PATCH] perf: missing export.h file
Message-ID: <20120329061231.GA1376@gmail.com>
References: <4F704A1E.2040401@hitachi.com>
 <20120328114745.GA17936@gmail.com>
 <1332939541.2325.7.camel@edumazet-glaptop>
 <20120328.174419.1377725053855749758.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328.174419.1377725053855749758.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 28 Mar 2012 14:59:01 +0200
> 
> >     CC util/rbtree.o
> > ../../lib/rbtree.c:24:26: error: linux/export.h: No such file or
> > directory
> > cc1: warnings being treated as errors
> > 
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> > I must be missing something, why nobody hits this error ???
> 
> Some don't hit it because it's already installed under /usr/include

The other reason is that it's also fixed in linux-next and in 
-tip, where most of the folks who build perf from scratch are 
concentrated. Will get tip:perf/urgent to Linus ASAP.

Thanks,

	Ingo
