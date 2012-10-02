Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab2JBV5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:57:04 -0400
Received: from mailgw.tensilica.com ([65.119.96.134]:41224 "EHLO
	mailgw.tensilica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2JBV5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:57:02 -0400
X-Greylist: delayed 1392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2012 17:57:02 EDT
From: Marc Gauthier <marc@tensilica.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Date: Tue, 2 Oct 2012 14:33:46 -0700
Subject: RE: [LKML] Re: Build regressions/improvements in v3.6
Thread-Topic: [LKML] Re: Build regressions/improvements in v3.6
Thread-Index: Ac2gzn/eAfLgbHpNT1Ca7e9Mmq4OdAAEEzpQ
Message-ID: <522C1DF17AF50042AD8AE87F7887BD3D05BF604843@exch.hq.tensilica.com>
References: <1349202763-1601-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdXcMVkcqTJdH2zdo9=a2efeeQmPGUr9GZqRMuRrAuMBvw@mail.gmail.com>
In-Reply-To: <CAMuHMdXcMVkcqTJdH2zdo9=a2efeeQmPGUr9GZqRMuRrAuMBvw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> xtensa-allmodconfig (hmm, this is not a new one, it felt through the
> cracks in -rc7 because of log line interleaving).
>
> Ugh, arch/xtensa/include/asm/regs.h defines way to generic symbols,
> like "MISC" (which causes the above breakage), and even a few
> 2-letter symbols, which surprisingly don't cause conflicts...

This particular one is already fixed in the xtensa linux-next tree
at git://github.com/czankel/xtensa-linux.git#for_next
(commit 36c74c2a16678e9ee6f08ef89eeebfdd1a96693d).

The short names in that header are for historical reasons.
It is indeed due for a cleanup.

-Marc
