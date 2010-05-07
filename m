Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0EGU4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:56:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0EGU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:56:52 -0400
Subject: Re: [PATCH v2] wait: use wrapper functions
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Changli Gao <xiaosuo@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Davide Libenzi <davidel@xmailserver.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <20100507135220.a972a6b2.akpm@linux-foundation.org>
References: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
	 <20100507135220.a972a6b2.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 22:56:47 +0200
Message-ID: <1273265807.1642.368.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 13:52 -0700, Andrew Morton wrote:
> On Fri,  7 May 2010 14:33:26 +0800
> Changli Gao <xiaosuo@gmail.com> wrote:
> 
> > epoll should not touch flags in wait_queue_t. This patch introduces a new
> > function __add_wait_queue_excl(), for the users, who use wait queue as a
> > LIFO queue.
> 
> __add_wait_queue_exclusive(), please.  Let's be consistent.

done

