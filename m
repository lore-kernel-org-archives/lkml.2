Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3ACODS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:03:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab3ACODO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:03:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHTX3d+bwTNEhzB78mqoz6prk0nw0U_-1YFR3Tje_-uQLyTMBQ@mail.gmail.com>
References: <CAHTX3d+bwTNEhzB78mqoz6prk0nw0U_-1YFR3Tje_-uQLyTMBQ@mail.gmail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: uapi __NR_syscalls for microblaze
Date: Thu, 03 Jan 2013 14:03:03 +0000
Message-ID: <26599.1357221783@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek <monstr@monstr.eu> wrote:

> just want to check with you if __NR_syscalls is necessary for user space. I
> see that powerpc and arm have this macro in asm not in uapi like Microblaze.
> If is not needed by user space, I should move it to asm/unistd.h

It isn't as far as I know...  I recommend putting your question on the
linux-arch mailing list.

David
