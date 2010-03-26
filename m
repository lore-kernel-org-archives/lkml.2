Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0CZDdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:33:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42662
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab0CZDdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:33:51 -0400
Date: Thu, 25 Mar 2010 20:34:14 -0700 (PDT)
Message-Id: <20100325.203414.149691680.davem@davemloft.net>
To: tglx@linutronix.de
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       gregkh@suse.de, acme@redhat.com
Subject: Re: [patch 0/2] Run interrupt handlers always with interrupts
 disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100326000325.917127328@linutronix.de>
References: <20100326000325.917127328@linutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 26 Mar 2010 00:06:44 -0000

> The following patch series removes the IRQF_DISABLED functionality
> from the core interrupt code and runs all interrupt handlers with
> interrupts disabled.
> 
> IRQF_DISABLED is kept as a define and scheduled for feature removal.
> 
> I booted and stressed that patches w/o any obvious fallout on more
> than 20 different systems in my arsenal of test machines which
> includes various embedded non x86 systems.
> 
> To debug eventual latency issues we (admittedly I talked acme into
> looking at that) want to extend perf with a top like tool to monitor
> the maximum runtime of interrupt handlers with the already existing
> tracepoints.

Acked-by: David S. Miller <davem@davemloft.net>
