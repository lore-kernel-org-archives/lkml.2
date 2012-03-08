Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2CHVvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:51:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682Ab2CHVvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:51:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120308184331.GC31129@windriver.com>
References: <20120308184331.GC31129@windriver.com> <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>, dwmw2@infradead.org
Cc: dhowells@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, mingo@redhat.com, arnd@arndb.de,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 00/29] Disintegrate and kill asm/system.h
Date: Thu, 08 Mar 2012 21:51:16 +0000
Message-ID: <15564.1331243476@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> You'll want to be grabbing some of these to close the gaps then:
> 
> http://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/
> 
> They have been a great help to me.

I have more toolchains available to me than are available there.

I managed to build binutils for every arch apart from unicore32 (and hexagon
and c6x which weren't upstream at the time).

Of those for which I have binutils, I couldn't manage to build gcc for avr32,
ia64, microblaze and openrisc.  I'm not sure whether I need a special compiler
for sh64, but it doesn't seem so.

Hopefully at some point they'll become RPMs in Fedora.  I just need to kick
David Woodhouse a bit to finish the review.

David
