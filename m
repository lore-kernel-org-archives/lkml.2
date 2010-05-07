Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab0EGUxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:53:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013Ab0EGUxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:53:02 -0400
Date: Fri, 7 May 2010 13:52:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH v2] wait: use wrapper functions
Message-Id: <20100507135220.a972a6b2.akpm@linux-foundation.org>
In-Reply-To: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
References: <1273214006-2979-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 May 2010 14:33:26 +0800
Changli Gao <xiaosuo@gmail.com> wrote:

> epoll should not touch flags in wait_queue_t. This patch introduces a new
> function __add_wait_queue_excl(), for the users, who use wait queue as a
> LIFO queue.

__add_wait_queue_exclusive(), please.  Let's be consistent.
