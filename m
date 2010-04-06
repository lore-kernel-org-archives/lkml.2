Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0DFXjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:39:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35001
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757626Ab0DFXjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:39:49 -0400
Date: Tue, 06 Apr 2010 16:39:51 -0700 (PDT)
Message-Id: <20100406.163951.115014932.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, acme@redhat.com, paulus@samba.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [patch 0/3] IRQ disable vs NMI
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100406132807.698467930@chello.nl>
References: <20100406132807.698467930@chello.nl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 06 Apr 2010 15:28:07 +0200

> This patch set tries to solve the local_irq_disable() vs NMI problem
> that SPARC has by providing new arch hooks and instrumenting the
> existing interface to WARN on conflicting usage.

Ok, two patches coming.

One which adds the sparc64 irqflags.h methods.

And one which annotates the ftrace functions, as needed.

With this I have the function tracer working.

Thanks!
