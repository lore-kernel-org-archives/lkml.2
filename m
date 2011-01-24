Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1AXJp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:45:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:50716 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab1AXJp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:45:28 -0500
Subject: Re: [patch 0/9] locking: Remove the deprecated lock initializers
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110123143631.392446736@linutronix.de>
References: <20110123143631.392446736@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 10:46:13 +0100
Message-ID: <1295862373.28776.310.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-23 at 15:16 +0000, Thomas Gleixner wrote:
> SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated since lockdep
> was merged. Fixup the last pertinacious users and remove the initializers.

Nice!,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
