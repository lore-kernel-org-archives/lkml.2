Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2HNPGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab2HNPGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:06:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <502A6759.3090802@nod.at>
References: <502A6759.3090802@nod.at> <15981.1344955883@warthog.procyon.org.uk> <502A613F.1090600@nod.at> <87a9xys53h.fsf@rustcorp.com.au> <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au> <50115FCF.4060708@xenotime.net> <502932A0.3060001@xenotime.net> <15532.1344954413@warthog.procyon.org.uk> <18600.1344956051@warthog.procyon.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 26 (uml)
Date: Tue, 14 Aug 2012 16:06:28 +0100
Message-ID: <18933.1344956788@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> wrote:

> I think arch/x86/um/Kconfig makes more sense.

warthog>ls arch/um
defconfig     Kconfig.common  Kconfig.um     Makefile-os-Linux  scripts/
drivers/      Kconfig.debug   kernel/        Makefile-ppc       sys-ia64/
include/      Kconfig.net     Makefile       Makefile-skas      sys-ppc/
Kconfig.char  Kconfig.rest    Makefile-ia64  os-Linux/

It doesn't exist.  Should I create it?

David
