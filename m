Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab1E0WBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:01:54 -0400
Received: from dspnet.fr ([188.165.44.67]:17959 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1E0WBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:01:52 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 18:01:52 EDT
Date: Fri, 27 May 2011 23:51:23 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527215123.GA45133@dspnet.fr>
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
 <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan>
 <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
 <20110527174644.GG4356@elte.hu>
 <BANLkTimGQh7P9O+BEd85Wm5iqzWg5DuYYg@mail.gmail.com>
 <20110527181724.GA6485@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527181724.GA6485@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 08:17:24PM +0200, Ingo Molnar wrote:
>  - A root exploit will still not give away the location of the
>    kernel (assuming module loading has been disabled after bootup),
>    so a rootkit cannot be installed 'silently' on the system, into
>    RAM only, evading most offline-storage-checking tools.
> 
>    With static linking this is not possible: reading the kernel image
>    as root trivially exposes the kernel's location.

There's something I don't get there.  If you managed to escalate your
priviledges enough that you have physical ram access, there's a
billion things you can do to find the kernel, including vector
tracing, pattern matching, looking at the page tables, etc.

What am I missing?

  OG.
