Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0EGKMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:12:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:40999 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab0EGKMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:12:19 -0400
Subject: Re: [PATCH v2] wait: use wrapper functions
From: Peter Zijlstra <peterz@infradead.org>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Davide Libenzi <davidel@xmailserver.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
References: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 12:12:14 +0200
Message-ID: <1273227134.1642.334.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 14:33 +0800, Changli Gao wrote:
> use wrapper functions
> 
> epoll should not touch flags in wait_queue_t. This patch introduces a new
> function __add_wait_queue_excl(), for the users, who use wait queue as a
> LIFO queue.
> 
> __add_wait_queue_tail_excl() is introduced too instead of
> add_wait_queue_exclusive_locked(). remove_wait_queue_locked() is removed, as
> it is a duplicate of __remove_wait_queue(), disliked by users, and with less
> users.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

Looks good to me. I can feed it to Ingo if he doesn't pick it up
himself.



