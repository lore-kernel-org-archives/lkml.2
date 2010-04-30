Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab0D3QtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:49:17 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:57218 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab0D3QtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:49:08 -0400
Date: Fri, 30 Apr 2010 09:53:21 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/7] cris: push down BKL into some device drivers
Message-ID: <20100430075320.GZ29275@axis.com>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272378265-10909-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 04:24:21PM +0200, Arnd Bergmann wrote:
> A number of cris specific device drivers still use the
> locked ->ioctl operation. Convert them to unlocked_ioctl
> with explicit lock_kernel calls.

Looks good, I've added this to the cris tree.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
