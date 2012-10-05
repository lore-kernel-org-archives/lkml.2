Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2JEIb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:31:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46519 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2JEIbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:31:21 -0400
Date: Fri, 5 Oct 2012 09:31:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: trisha yad <trisha1march@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: DEBUG_STACKOVERFLOW issue on ARM
Message-ID: <20121005083113.GG4625@n2100.arm.linux.org.uk>
References: <CAGr+u+yxC3nPrsW+EU9qwh0ggjqrg9K=1ftQXfds8unMiDMZsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr+u+yxC3nPrsW+EU9qwh0ggjqrg9K=1ftQXfds8unMiDMZsA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 05:18:56PM +0530, trisha yad wrote:
> I wish to know how can I support this function in 3.0 ?

If your description is correct, then all you need to do is to ensure
that you route interrupts to other CPUs.

You can do that by running the userspace irqbalance daemon.
