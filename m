Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0D1OFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:05:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0D1OFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:05:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Date: Wed, 28 Apr 2010 16:05:26 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, John Kacur <jkacur@redhat.com>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <201004261329.28427.arnd@arndb.de> <20100427092530.GD11348@elte.hu>
In-Reply-To: <20100427092530.GD11348@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004281605.26248.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18QK5wPzCZleolJscCb+fw7rip2+BA31VyOF9b
 ih49qqd2xZwfkLM+gQYPvwuQsL/vbiTPJVV32gOzOODfFpNxgp
 +QFF54HHXf5YK4kt05qNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, Ingo Molnar wrote:
> * Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Monday 26 April 2010, Ingo Molnar wrote:
> > > This could be done all automated for a hundred old drivers if need to be. 
> > > There would be no bkl_ioctl's left.
> > 
> > I don't think it can be fully automated. [...]
> 
> Corner cases are not a problem as long as the risk of them going unnoticed is 
> lower than the risk of a manual conversion introducing bugs.

I actually support your idea of automatic conversion of modules in the
way you lined out, but would not want to apply it to the entire kernel
at once, but only to modules that were manually inspected to be safe for
doing this.

This minimizes both the risk from corner cases and the risk from manual
conversion.

	Arnd
