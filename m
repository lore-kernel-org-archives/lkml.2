Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2HJMvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:51:55 -0400
Received: from seven.medozas.de ([5.9.24.206]:42159 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab2HJMvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:51:52 -0400
Date: Fri, 10 Aug 2012 14:51:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: David Miller <davem@davemloft.net>
cc: dhowells@redhat.com, arnd@arndb.de, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: Re: [PATCH] MPILIB: Provide count_leading/trailing_zeros() based on
 arch functions
In-Reply-To: <20120720.174641.159144353919647856.davem@davemloft.net>
Message-ID: <alpine.LNX.2.01.1208101451280.23731@frira.zrqbmnf.qr>
References: <201207201353.34324.arnd@arndb.de> <20120720125657.15422.12922.stgit@warthog.procyon.org.uk> <5723.1342794099@warthog.procyon.org.uk> <20120720.174641.159144353919647856.davem@davemloft.net>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-07-21 02:46, David Miller wrote:
>> Arnd Bergmann <arnd@arndb.de> wrote:
>> 
>>> I don't generally like to put stuff into asm-generic when it's unlikely
>>> to be overridden by architectures. It would really belong into
>>> include/linux, but then again we have all the other bitops in asm-generic
>>> as well, so whatever...
>> 
>> Some arches (such as Sparc, I think) have count-leading-zero instructions.
>
>Yes, newer sparc64 chips have leading-zero-detect, and I was pretty
>sure that powerpc had something similar.  It's called count-leading-
>zeros or something like that.

And gcc has a __builtin_clz.
