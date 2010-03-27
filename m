Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0C0Pj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:39:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60074
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab0C0Pj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:39:57 -0400
Date: Sat, 27 Mar 2010 08:40:20 -0700 (PDT)
Message-Id: <20100327.084020.48501258.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com
Subject: Re: [patch 0/6] rcu head debugobjects
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100327153233.993367557@efficios.com>
References: <20100327153233.993367557@efficios.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Sat, 27 Mar 2010 11:32:33 -0400

> Unless people have any objection, it should be ready to be merged. I
> think the appropriate maintainer to perform this merge would be Paul
> E. McKenney, because this patchset is RCU-related.

Agreed, and I'm fine with the networking parts, so:

Acked-by: David S. Miller <davem@davemloft.net>
