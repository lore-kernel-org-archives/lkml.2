Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0EFCst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:48:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:55984 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0EFCss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:48:48 -0400
Date: Thu, 6 May 2010 12:45:56 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/7] KEYS: Fix an RCU warning in the reading of user
 keys
In-Reply-To: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1005061242540.23351@tundra.namei.org>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay... patches 1-4 have gone into -linus, along with 'KEYS: Fix RCU 
handling in key_gc_keyring()'

The should probably all be in -stable (see the most recent 'keys' patches 
in -linus).

Patches 5 & 6 are in:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

The final patch does not apply to my tree -- please rebase it.


- James
-- 
James Morris
<jmorris@namei.org>
