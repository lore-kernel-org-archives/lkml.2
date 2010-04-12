Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab0DLUbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:31:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab0DLUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:30:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH tip/core/urgent 1/4] rcu: add rcu_access_pointer and rcu_dereference_protected
Date: Mon, 12 Apr 2010 22:30:42 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu
References: <1270792042-9358-1-git-send-email-paulmck@linux.vnet.ibm.com> <20100409165735.GB2421@linux.vnet.ibm.com> <20100412192441.GB27341@feather>
In-Reply-To: <20100412192441.GB27341@feather>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004122230.43053.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+nQDBZOkI9RA12m9OgYj6q/sZvne7mwFMRzVv
 gqIeKMEZ5NeMAamoehd2VoeYqCO0NaUocxKDxh+clwn/VEADYt
 Fk10BjbugKXhhDd7/RUdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 April 2010 21:24:42 Josh Triplett wrote:
> If you want to prevent people from deferencing the pointer directly, or
> from assigning it to some other pointer, you could use Sparse's
> __attribute__((noderef)) and
> __attribute__((address_space(...)).
> 
> See the definitions of __user and __iomem in include/linux/compiler.h
> for instance.  (And, looking at that file, now __percpu.  Nice!)
> 
> You'd then have to explicitly use __force at the point where you
> legitimately dereference it.

I have started a patch set for doing that a few weeks ago, still need
to pick up that work again. Are there any other patches besides this
series that I should base on top of now?

	Arnd
