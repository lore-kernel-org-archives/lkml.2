Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0D0RWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:22:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31232 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0D0RWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=swd1zytASe5khtBWEP0B2ZWV0nvN6AI7dMs++Ahf58qePPvtGvaQm+DZ0GH5EtES4A
         Xi7W2KOD5Z02NklKjGtFCck2ZtLvcGYACAV83ay1q1rlEsqqQYuCTvkkeSTU1n5phh81
         vyJm/oUJbDu3TzV5kw/pZZi9Zp39o+JOzfUtI=
Date: Tue, 27 Apr 2010 19:22:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Cris <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 3/7] cris: push down BKL into some device drivers
Message-ID: <20100427172235.GA5586@nowhere>
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
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>


(Adding some more cris related Cc on this one)

