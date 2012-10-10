Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2JJRvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:51:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:47259 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2JJRvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:51:14 -0400
Message-ID: <1349891458.1279.23.camel@twins>
Subject: Re: [PATCH V2] task_work: avoid unneeded cmpxchg() in
 task_work_run()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Date: Wed, 10 Oct 2012 19:50:58 +0200
In-Reply-To: <20121010175032.GA22642@redhat.com>
References: <50729A78.9090601@cn.fujitsu.com>
	 <20121008123815.GA847@redhat.com> <1349780697.7880.14.camel@twins>
	 <5075098E.9090808@cn.fujitsu.com> <20121010175032.GA22642@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 19:50 +0200, Oleg Nesterov wrote:
> 
> But you did not answer, and I am curious. What was your original
> motivation? Is xchg really faster than cmpxchg? 

And is this true over multiple architectures? Or are we optimizing for
x86_64 (again) ?
