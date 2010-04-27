Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0D0PcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:32:21 -0400
Received: from lazybastard.de ([212.112.238.170]:55036 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0D0PcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:32:20 -0400
Date: Tue, 27 Apr 2010 17:32:10 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
Message-ID: <20100427153209.GD16794@logfs.org>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-2-git-send-email-arnd@arndb.de> <20100427145804.GA16794@logfs.org> <201004271705.50499.arnd@arndb.de> <20100427150919.GB16794@logfs.org> <alpine.LFD.2.00.1004271725490.3318@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1004271725490.3318@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 April 2010 17:27:19 +0200, John Kacur wrote:
> 
> Hasn't the "current" merge window been over with for weeks? I was assuming 
> that bkl push down, or other bkl patches are for the next merge window.

That's what I was thinking.  But some of the bkl related discussion gave
me the impression that such patches were still being merged.  So I
wanted to be sure.

Jörn

-- 
It is better to die of hunger having lived without grief and fear,
than to live with a troubled spirit amid abundance.
-- Epictetus
