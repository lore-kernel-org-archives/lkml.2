Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0ICJTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab0ICJTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:19:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <m3vd6nmd68.fsf@hase.home>
References: <m3vd6nmd68.fsf@hase.home> <19747.1283422807@redhat.com> <20100902102158.19806.14133.stgit@warthog.procyon.org.uk> <m38w3kns4r.fsf@hase.home> <AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com>
To: Andreas Schwab <schwab@redhat.com>
Cc: dhowells@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        gerg@snapgear.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select m68knommu contributions
Date: Fri, 03 Sep 2010 10:18:40 +0100
Message-ID: <3048.1283505520@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@redhat.com> wrote:

> You are almost able to use the uclinux compiler for both, except that
> currently __uClinux__ is hardcoded.

The m68knommu arch Makefile in the kernel could specify it on the compiler
command line, then m68k compilers should be possible.

The kernel should probably also set appropriate -mcpu= and -mtune= flags,
depending on the type of kernel selected.

David
