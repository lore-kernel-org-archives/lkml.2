Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0JKWQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:16:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741Ab0JKWQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:16:23 -0400
Date: Mon, 11 Oct 2010 15:14:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, peterz@infradead.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH 1/1] um: Get rid of __do_IRQ()
Message-Id: <20101011151447.1a022f25.akpm@linux-foundation.org>
In-Reply-To: <1286832575-21474-1-git-send-email-richard@nod.at>
References: <1286832575-21474-1-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 23:29:35 +0200
Richard Weinberger <richard@nod.at> wrote:

> This patch removes __do_IRQ() from user mode linux.

I'd never actually noticed CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ.

What's the plan here?  Are all architectures supposed to me migrating
away from __do_IRQ() and over to generic_handle_irq(), or what?

