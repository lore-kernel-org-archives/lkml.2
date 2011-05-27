Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1E0Sos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:44:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52823 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1E0Sor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:44:47 -0400
Date: Fri, 27 May 2011 11:43:58 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com, davem@davemloft.net,
        eranian@google.com, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527184358.GA19633@outflux.net>
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
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 08:17:24PM +0200, Ingo Molnar wrote:
>  - Boot time dynamic randomization allows randomization of 'mass 
>    install' systems, where the same image is used, to still be 
>    randomized: for example a million phones all with the same Flash 
>    ROM image and no 'install' performed at all on them.
> 
>    With static randomization these systems will all have the same
>    kernel addresses.
> 
>  - Boot time dynamic randomization allows read-only systems to still 
>    be randomized: for example internet cafes that use some popular 
>    pre-packaged kiosk-mode live-DVD. They probably wont bother 
>    randomizing and relinking the ISOs per machine and burning per 
>    machine DVDs ...

These 2 points are pretty significant, IMO.

And frankly, distros almost fall into these categories already. IIUC,
a distro would need to ship all of the .o files from each config of the
kernel they ship so each system could do the relinking. That's not a
small foot print to suddenly add to base installs.

-Kees

-- 
Kees Cook
Ubuntu Security Team
