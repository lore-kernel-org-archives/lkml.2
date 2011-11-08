Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab1KHMPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:15:13 -0500
Received: from mail001.aei.ca ([206.123.6.130]:49444 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab1KHMPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:15:10 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Valdis.Kletnieks@vt.edu
Cc: John Stoffel <john@stoffel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Date: Tue, 08 Nov 2011 07:15:04 -0500
Message-ID: <15917317.H6lYS7chMM@grover>
Organization: me
User-Agent: KMail/4.7.3 (Linux/3.1.0-crc+; KDE/4.7.3; x86_64; ; )
In-Reply-To: <201529.1320618774@turing-police.cc.vt.edu>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default> <20139.5644.583790.903531@quad.stoffel.home> <201529.1320618774@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 November 2011 17:32:54 Valdis.Kletnieks@vt.edu wrote:
> On Fri, 28 Oct 2011 16:52:28 EDT, John Stoffel said:
> > Dan> "WHY" this is such a good idea is the same as WHY it is useful to
> > Dan> add RAM to your systems. 
> >
> > So why would I use this instead of increasing the physical RAM?
> 
> You're welcome to buy me a new laptop that has a third DIMM slot. :)
> 
> There's a lot of people running hardware that already has the max amount of
> supported RAM, and who for budget or legacy-support reasons can't easily do a
> forklift upgrade to a new machine.

I've got three boxes with this problem here.  Hense my support for frontswap/cleancache.

Ed

> > if I've got a large system which cannot physically use any more
> > memory, then it might be worth my while to use TMEM to get more
> > performance out of this expensive hardware.
> 
> It's not always a large system....
