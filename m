Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700Ab2JLQCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab2JLQCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:02:16 -0400
Date: Fri, 12 Oct 2012 18:03:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/1] (Was: [regression] boot failure on alpha, bisected)
Message-ID: <20121012160337.GA30881@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121006204736.GA1830@ds20.borg.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06, Thorsten Kranzkowski wrote:
>
> After upgrading from v3.5-rc7 to current git my system oopses and locks up
> early in the boot sequence.

OK, I am sending the patch which I already showed.

Perhaps we should only add the warning and local_irq_enable()
should go into arch/alpha/kernel/signal.c:do_notify_resume().

In any case arch/alpha/ should be fixed imho.

Oleg.

