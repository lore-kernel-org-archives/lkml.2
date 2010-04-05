Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0DEBBD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 21:01:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48920
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab0DEBAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 21:00:55 -0400
Date: Sun, 04 Apr 2010 18:00:57 -0700 (PDT)
Message-Id: <20100404.180057.109331958.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100404122113.GD5177@nowhere>
References: <20100404121851.GC5177@nowhere>
	<20100404122113.GD5177@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 4 Apr 2010 14:21:19 +0200

> Forgot the config, it's in attachment.

I get them too when even trying to use the function tracer in some
simple way.  They occur in random places and eventually the entire
machine wedges and is unusuable.

I suspect there is some bug that ends up corrupting memory, so I
started trying to debug this last night when I first saw it.

I'll let you know if I make any progress.
