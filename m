Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0CYMzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:55:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab0CYMzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:55:23 -0400
Date: Thu, 25 Mar 2010 13:55:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
In-Reply-To: <201003242240.54907.arnd@arndb.de>
Message-ID: <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz>
References: <201003242240.54907.arnd@arndb.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Arnd Bergmann wrote:

> I've spent some time continuing the work of the people on Cc and many others
> to remove the big kernel lock from Linux and I now have bkl-removal branch
> in my git tree at git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
> that lets me run a kernel on my quad-core machine with the only users of the BKL
> being mostly obscure device driver modules.

	config USB
	        tristate "Support for Host-side USB"
	        depends on USB_ARCH_HAS_HCD && BKL

Well, that's very interesting definition of "obscure" :)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

