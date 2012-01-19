Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2ASED0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 23:03:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:42830 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab2ASEDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 23:03:25 -0500
Date: Thu, 19 Jan 2012 15:03:20 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Steve Dickson <steved@redhat.com>
Subject: Re: [PATCH] KEYS: Allow special keyrings to be cleared
In-Reply-To: <20120118153145.30490.61734.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1201191502540.30715@tundra.namei.org>
References: <20120118153145.30490.61734.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012, David Howells wrote:

> The kernel contains some special internal keyrings, for instance the DNS
> resolver keyring :
> 
> 2a93faf1 I-----     1 perm 1f030000     0     0 keyring   .dns_resolver: empty
> 
> It would occasionally be useful to allow the contents of such keyrings to be
> flushed by root (cache invalidation).
> 

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next-queue
