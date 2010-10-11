Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0JKWXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:23:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:34425 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab0JKWXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:23:15 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] um: Get rid of __do_IRQ()
Date: Tue, 12 Oct 2010 00:23:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, peterz@infradead.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
References: <1286832575-21474-1-git-send-email-richard@nod.at> <20101011151447.1a022f25.akpm@linux-foundation.org>
In-Reply-To: <20101011151447.1a022f25.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010120023.10861.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 12 Oktober 2010, 00:14:47 schrieb Andrew Morton:
> What's the plan here?  Are all architectures supposed to me migrating
> away from __do_IRQ() and over to generic_handle_irq(), or what?

Yes.

Documentation/feature-removal-schedule.txt:

What: __do_IRQ all in one fits nothing interrupt handler
When: 2.6.32
Why:  __do_IRQ was kept for easy migration to the type flow handlers.
  More than two years of migration time is enough.
Who:  Thomas Gleixner <tglx@linutronix.de>

Thanks,
//richard
