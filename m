Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0C2UL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:11:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36983 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0C2ULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:11:25 -0400
Date: Mon, 29 Mar 2010 22:11:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, gregkh@suse.de
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock II
Message-ID: <20100329201123.GG20695@one.firstfloor.org>
References: <201003242240.54907.arnd@arndb.de> <201003291348.37997.arnd@arndb.de> <87fx3jqpi3.fsf@basil.nowhere.org> <201003291643.01214.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003291643.01214.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The patch looks correct, but I probably wouldn't bother with the rename,
> > > and simply drop the BKL in the caller.
> > 
> > I think a rename is better, I take compile errors over subtle
> > breakage any day.
> 
> ok, fine with me.

I updated the git tree removing the unneeded serial change. Feel free to pull.

git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git usb-bkl

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
