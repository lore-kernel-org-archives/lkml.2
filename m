Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2GMEEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 00:04:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:59000 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab2GMEEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 00:04:39 -0400
Date: Fri, 13 Jul 2012 14:04:28 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Arnd Bergmann <arnd@arndb.com>
Subject: Re: [PATCH] MPILIB: Provide count_leading/trailing_zeros() based on
 arch functions
In-Reply-To: <20120706154520.14013.92580.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.02.1207131403240.5602@tundra.namei.org>
References: <20120706154520.14013.92580.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, David Howells wrote:

> Provide count_leading/trailing_zeros() macros based on extant arch bit scanning
> functions rather than reimplementing from scratch in MPILIB.
> 
> Whilst we're at it, turn count_foo_zeros(n, x) into n = count_foo_zeros(x).
> 
> Also move the definition to asm-generic as other people may be interested in
> using it.

Please rebase this against
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
