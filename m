Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab2C1Lgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:36:32 -0400
Received: from tundra.namei.org ([65.99.196.166]:52968 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab2C1Lg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:36:29 -0400
Date: Wed, 28 Mar 2012 22:36:21 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/9] KEYS: Use the compat keyctl() syscall wrapper on
 Sparc64 for Sparc32 compat
In-Reply-To: <10701.1332931934@redhat.com>
Message-ID: <alpine.LRH.2.02.1203282233480.30781@tundra.namei.org>
References: <20120328104607.10417.85745.stgit@warthog.procyon.org.uk> <10701.1332931934@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012, David Howells wrote:

> 
> Can you push these to Linus in this merge window, please?

Only serious bugs at this point.

Patch #1 seems like the only candidate.  What impact does it have?

If DaveM has patches still to push for Sparc, it could go in those.


- James
-- 
James Morris
<jmorris@namei.org>
