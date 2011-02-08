Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1BHQ2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:28:09 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:41848 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689Ab1BHQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:28:07 -0500
Date: Tue, 8 Feb 2011 17:27:45 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Hui Zhu <teawater@gmail.com>
Cc: Tom Tromey <tromey@redhat.com>, linux-kernel@vger.kernel.org,
        Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>,
        Alexandre Oliva <aoliva@redhat.com>
Subject: Re: [PATCH] Linux Kernel GDB tracepoint module 2011-02-05
Message-ID: <20110208162745.GA28849@host1.dyn.jankratochvil.net>
References: <AANLkTikhfhYjvmvXtjW-Mszpq8d_3Syo=H4zqWe+1hEg__12255.0142732964$1296923928$gmane$org@mail.gmail.com>
 <m3hbcfzu9u.fsf@fleche.redhat.com>
 <AANLkTinMx8mJYiDps3TuuaA1B4NLHi-PuCKm2=sTqyR0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinMx8mJYiDps3TuuaA1B4NLHi-PuCKm2=sTqyR0@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Feb 2011 14:23:52 +0100, Hui Zhu wrote:
> BTW does VTA can handle the issue that after -O2 a lot of code
> execution order is worong?

"is_stmt" - not specifically VTA but Alexandre Oliva plans (/works on) it.

It is a part of his "Consistent Views at Recommended Breakpoints":
	http://www.lsd.ic.unicamp.br/~oliva/
	http://www.lsd.ic.unicamp.br/~oliva/papers/sfn/


Regards,
Jan
