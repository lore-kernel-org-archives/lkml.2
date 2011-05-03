Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1ECAU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:20:56 -0400
Received: from [65.99.196.166] ([65.99.196.166]:41563 "EHLO tundra.namei.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab1ECAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:20:55 -0400
Date: Tue, 3 May 2011 10:20:13 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: dave@linux.vnet.ibm.com, steffen.klassert@secunet.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
        sds@tycho.nsa.gov
Subject: Re: [PATCH -v2] flex_arrays: allow zero length flex arrays
In-Reply-To: <20110428195402.6677.80147.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.1105031019400.19644@tundra.namei.org>
References: <20110428195402.6677.80147.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011, Eric Paris wrote:

> Just like kmalloc will allow one to allocate a 0 length segment of memory
> flex arrays should do the same thing.  It should bomb if you try to use
> something, but it should at least allow the allocation.

This patch does not apply to current -linus.

-- 
James Morris
<jmorris@namei.org>
