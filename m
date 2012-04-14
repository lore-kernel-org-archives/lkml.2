Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2DNQjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:39:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34787 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2DNQjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:39:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120414161953.GA18140@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 09:38:50 -0700
X-Google-Sender-Auth: qBMXRPaRY51ZZzh2PkEf9W22ywk
Message-ID: <CA+55aFw94CZOLu-DF03sXV5gt+JPNegoCt2agvaTfApr+ndmpg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/7] rcu: v2 Inlinable preemptible rcu_read_lock() and rcu_read_unlock()
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 9:19 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> This series is version two of the inlinable versions of preemptible
> RCU's __rcu_read_lock() and __rcu_read_unlock().

Btw, what is this supposed to apply on top of? It doesn't seem to
apply cleanly to either v3.3, v3.4-rc[12], or current top-of-tree.

I can make it apply by reducing the context to just one line for
patch#6, but your base seems to be odd.

                       Linus
