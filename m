Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab1E0RVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:21:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:50396 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1E0RVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:21:16 -0400
Date: Fri, 27 May 2011 10:20:04 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com, davem@davemloft.net,
        eranian@google.com, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527172004.GZ19633@outflux.net>
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
 <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan>
 <4DDFDBD2.2000904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDFDBD2.2000904@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:13:54AM -0700, H. Peter Anvin wrote:
> On 05/27/2011 10:10 AM, Dan Rosenberg wrote:
> > 
> > Just to play devil's advocate, how is it easier for a local attacker to
> > figure out where kernel internals are if it's been relinked vs.
> > randomized at load time, assuming we follow through on fixing the info
> > leaks?
> > 
> 
> You can read the on-disk kernel file and find out.

If we're still operating under the assumption of "defend against non-root",
distros can trivially make the on-disk kernels 0400.

-Kees

-- 
Kees Cook
Ubuntu Security Team
