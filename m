Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1E0RKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:10:44 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:63505 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1E0RKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:10:42 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
In-Reply-To: <20110527170045.GB4356@elte.hu>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
	 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
	 <20110527170045.GB4356@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 13:10:30 -0400
Message-ID: <1306516230.3339.17.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 19:00 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > If you compile your own kernel version, you're already home free, 
> > and load-time randomization is pointless.

> The problem with your relinking solution is that a local attacker can 
> easily figure out where the kernel is. So this does not protect 
> against the more common break-in scenario.
> 
> Kernel image randomization makes this last step really 
> indeterministic and thus dangerous to attackers.
> 

Just to play devil's advocate, how is it easier for a local attacker to
figure out where kernel internals are if it's been relinked vs.
randomized at load time, assuming we follow through on fixing the info
leaks?

It seems to me that the only functional difference is that subsequent
reboots will yield the same memory layout, which is a real drawback
worth considering.

-Dan

> Thanks,
> 
> 	Ingo


