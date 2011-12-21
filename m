Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1LURER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:04:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38213 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1LUREQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:04:16 -0500
Message-ID: <1324487037.10752.22.camel@twins>
Subject: Re: [RFC][PATCH 1/7] arch, early_printk: Consolidate early_printk()
 implementations
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 18:03:57 +0100
In-Reply-To: <20111221111143.346150952@chello.nl>
References: <20111221105739.798864333@chello.nl>
	 <20111221111143.346150952@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 11:57 +0100, Peter Zijlstra wrote:

For correctness sake, quilt ate:

From: Thomas Gleixner <tglx@linutronix.de>

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [ expose early_vprintk(), change return values ]
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> --- 
