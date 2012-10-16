Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2JPT5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:57:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47759 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2JPT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:57:20 -0400
MIME-Version: 1.0
In-Reply-To: <20121015191018.GA4816@redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Oct 2012 12:56:58 -0700
X-Google-Sender-Auth: 1JTcenDbSkh4k_U9HZHLyhe62tw
Message-ID: <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> This patch adds the new sleeping lock, brw_mutex. Unlike rw_semaphore
> it allows multiple writers too, just "read" and "write" are mutually
> exclusive.

So those semantics just don't sound sane. It's also not what any kind
of normal "rw" lock ever does.

So can you explain why these particular insane semantics are useful,
and what for?

                  Linus
