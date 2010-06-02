Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0FBJNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:13:13 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:55415 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0FBJNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:13:11 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+3aIibppu0283ogF9SEP/jQF66A==
X-RZG-CLASS-ID: mo00
Date: Wed, 2 Jun 2010 11:13:01 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: acquire_console_mutex: WARNING: at
 2.6.33.4-rt20/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
Message-ID: <20100602091301.GA9242@aepfle.de>
References: <20100524225357.GA19513@aepfle.de>
 <201005251318.37242.arnd@arndb.de>
 <20100530213902.GA3619@aepfle.de>
 <201005311329.07182.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201005311329.07182.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, Arnd Bergmann wrote:

> On Sunday 30 May 2010, Olaf Hering wrote:
> > > You could try to pull in the blk/tty branch from
> > > http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git and enable
> > > CONFIG_TTY_MUTEX to see if that gives you better lockdep output,
> > > because that replaces the implicit dropping of the BKL with mutex operations
> > > that lockdep is aware of.
> > 
> > CONFIG_TTY_MUTEX depends on SMP and this ARM system does not support
> > CONFIG_SMP, its hidden by Kconfig dependencies.


Arnd,

I do not have access to this ARM board anymore, and other systems I own
do not have hardware for serial console.
So I can not test or debug this further.


Olaf
