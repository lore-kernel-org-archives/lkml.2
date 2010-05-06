Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab0EFM0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 08:26:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:59525 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab0EFM0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 08:26:09 -0400
Date: Thu, 6 May 2010 22:25:44 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/7] KEYS: Fix an RCU warning in the reading of user
 keys
In-Reply-To: <6966.1273142334@redhat.com>
Message-ID: <alpine.LRH.2.00.1005062159460.29467@tundra.namei.org>
References: <alpine.LRH.2.00.1005061242540.23351@tundra.namei.org> <20100430133208.2126.56765.stgit@warthog.procyon.org.uk> <6966.1273142334@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > The final patch does not apply to my tree -- please rebase it.
> 
> Your tree is not up to date with respect to Linus's: you're missing the three
> patches he pulled in yesterday.

Ok, I forgot to pull from Linus' tree before merging locally, looks fine 
now.

-- 
James Morris
<jmorris@namei.org>
