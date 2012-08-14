Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2HNPrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab2HNPry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:47:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120814151345.GB30856@linux-mips.org>
References: <20120814151345.GB30856@linux-mips.org> <87d32us55c.fsf@rustcorp.com.au> <1344332473-19842-1-git-send-email-jonas.gorski@gmail.com> <31154.1344872382@warthog.procyon.org.uk> <32504.1344953290@warthog.procyon.org.uk>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: Fix module.c build for 32 bit
Date: Tue, 14 Aug 2012 16:47:43 +0100
Message-ID: <22516.1344959263@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle <ralf@linux-mips.org> wrote:

> +extern int apply_r_mips_none(struct module *me, u32 *location, Elf_Addr v);

This needs to be in a header file, not a .c file.

David
