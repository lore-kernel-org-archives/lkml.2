Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1LSAZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:25:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:45693 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab1LSAZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:25:07 -0500
Date: Mon, 19 Dec 2011 11:24:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Thomas Meyer <thomas@m3y3r.de>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] selinux: Casting (void *) value returned by kmalloc is
 useless
In-Reply-To: <1321569820.1624.261.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1112191124190.22702@tundra.namei.org>
References: <1321569820.1624.261.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Thomas Meyer wrote:

> The semantic patch that makes this change is available
> in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---

Applied to
git://selinuxproject.org/~jmorris/linux-security next

-- 
James Morris
<jmorris@namei.org>
