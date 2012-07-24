Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2GXNT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:19:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab2GXNT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:19:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com>
References: <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com> <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Subject: Re: [PATCH 00/13] UAPI header file split
Date: Tue, 24 Jul 2012 14:19:12 +0100
Message-ID: <28702.1343135952@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> In the uapi-split branch, there are now 44 empty Kbuild files. Was
> that intended? Or, should these files rather be removed by your
> patches?

To be removed by a later patch, I think.  Getting rid of some of them isn't
trivial - ones in arch/x/include/asm/Kbuild for example - because that Kbuild
is referenced by common code IIRC as a function of the arch.

David
