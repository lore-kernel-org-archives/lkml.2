Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2GUArK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:47:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56726 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2GUAqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:46:50 -0400
Date: Fri, 20 Jul 2012 17:46:41 -0700 (PDT)
Message-Id: <20120720.174641.159144353919647856.davem@davemloft.net>
To: dhowells@redhat.com
Cc: arnd@arndb.de, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: Re: [PATCH] MPILIB: Provide count_leading/trailing_zeros() based
 on arch functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <5723.1342794099@warthog.procyon.org.uk>
References: <201207201353.34324.arnd@arndb.de>
	<20120720125657.15422.12922.stgit@warthog.procyon.org.uk>
	<5723.1342794099@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 20 Jul 2012 15:21:39 +0100

> Arnd Bergmann <arnd@arndb.de> wrote:
> 
>> I don't generally like to put stuff into asm-generic when it's unlikely
>> to be overridden by architectures. It would really belong into
>> include/linux, but then again we have all the other bitops in asm-generic
>> as well, so whatever...
> 
> Some arches (such as Sparc, I think) have count-leading-zero instructions.

Yes, newer sparc64 chips have leading-zero-detect, and I was pretty
sure that powerpc had something similar.  It's called count-leading-
zeros or something like that.

