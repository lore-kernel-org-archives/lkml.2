Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab2EGUGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:06:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:35974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab2EGUGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:06:42 -0400
Subject: Re: [patch 0/8] cpuidle: Fix and replace cpu_idle_wait copied code
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120507175450.513667947@linutronix.de>
References: <20120507175450.513667947@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 22:06:32 +0200
Message-ID: <1336421192.27020.78.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 17:59 +0000, Thomas Gleixner wrote:
> cpu_idle_wait() is available in several identical copies all over
> arch/ plus a broken variant.
> 
> This series fixes the broken one first and then replaces all the
> identical ones with a generic version.
> 
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

