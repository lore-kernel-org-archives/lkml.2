Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1BPSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 13:16:27 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61269 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1BPSQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 13:16:24 -0500
MIME-Version: 1.0
X-Originating-IP: [141.3.215.46]
In-Reply-To: <20110209191755.GE9533@thunk.org>
References: <1297168678.2190.21.camel@marvin>
	<AANLkTim7YVg1BTEjyhYShgZNL3oKu+zFywC7+NgFvT3z@mail.gmail.com>
	<1297269019.4888.91.camel@marvin>
	<20110209191755.GE9533@thunk.org>
Date: Wed, 16 Feb 2011 19:16:22 +0100
Message-ID: <AANLkTik2m5L-92Gp1OwE3GU6Qu-07QjGio-x2YqfVN8Y@mail.gmail.com>
Subject: Re: mmap, the language go, problems with the linux kernel
From: Hannes Frederic Sowa <hannes@mailcolloid.de>
To: "Ted Ts'o" <tytso@mit.edu>, Martin Capitanio <m@capitanio.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, golang-dev <golang-dev@googlegroups.com>,
        Russ Cox <rsc@golang.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Albert Strasheim <fullung@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 8:17 PM, Ted Ts'o <tytso@mit.edu> wrote:
> AIX and the BSD's don't implement RLIMIT_AS at all.  Solaris does, but
> the man page just says "total available memory", again without
> specifying what that means.  Solaris also has a RLIMIT_VMEM, which is
> the total amount of virtual address space, so apparently Solaris seems
> to think that RLIMIT_VMEM and RLIMIT_AS are different things.

Actually, no:
| ./uts/common/sys/resource.h:#define RLIMIT_AS RLIMIT_VMEM

They have a userland daemon called rcapd which enforces rss-limits on
process-groups by paging out their data.
