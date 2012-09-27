Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2I0OrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:47:14 -0400
Received: from mx0.aculab.com ([213.249.233.131]:43856 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750949Ab2I0OrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:47:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v6] hashtable: introduce a small and naive hashtable
Date: Thu, 27 Sep 2012 15:36:45 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B700C@saturn3.aculab.com>
In-Reply-To: <20120927131118.GC30139@Krystal>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v6] hashtable: introduce a small and naive hashtable
thread-index: Ac2csZo+tmrnRMpFTrq9gU2Iqhr5qgACr4PA
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com> <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com> <20120926143905.GB22699@Krystal> <1348675764.22822.56.camel@gandalf.local.home> <20120926161956.GB28648@Krystal> <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com> <50640F4E.4020305@gmail.com> <20120927131118.GC30139@Krystal>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
        "Sasha Levin" <levinsasha928@gmail.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, <torvalds@linux-foundation.org>,
        <tj@kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
        <neilb@suse.de>, <bfields@fieldses.org>, <ejt@redhat.com>,
        <snitzer@redhat.com>, <edumazet@google.com>, <josh@joshtriplett.org>,
        <rmallon@gmail.com>, <palves@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Moreover, if your thinking is that we do not need a static inline
> function replicated at every caller, maybe we should introduce a
> lib/hashtable.c that implements those 2 functions.

That was my thought...
Given their nature, I'd guess they aren't critical path.
Probably not worth adding an entire source file though.

With regard to 'inline', when I say it, I really mean it!
Unfortunately some people seem to just type it anyway (rather
like 'register' used to get used) - so the compilers start
ignoring the request.
At least some versions of gcc will usually inline static
functions that are only called once - but even then it can
change its mind for almost no reason.

	David



