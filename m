Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0DFLNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:13:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37509
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498Ab0DFLNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:13:40 -0400
Date: Tue, 06 Apr 2010 04:13:42 -0700 (PDT)
Message-Id: <20100406.041342.183031470.davem@davemloft.net>
To: peterz@infradead.org
Cc: fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       paulus@samba.org
Subject: Re: [RFC][PATCH] lockdep: WARN about local_irq_{en,dis}able in NMI
 context
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270552321.1595.42.camel@laptop>
References: <20100405194055.GA5265@nowhere>
	<20100406.025049.267615796.davem@davemloft.net>
	<1270552321.1595.42.camel@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 06 Apr 2010 13:12:01 +0200

> One thing we can do is make the code WARN about this, how about
> something like the below

It's going to warn every bootup in cpu_clock() on x86.
