Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229Ab0GPBiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 21:38:50 -0400
Received: from tundra.namei.org ([65.99.196.166]:55504 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935038Ab0GPBis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 21:38:48 -0400
Date: Fri, 16 Jul 2010 11:38:43 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
cc: "greg@kroah.com" <greg@kroah.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH][securityfs][2.6.34] Drop dentry reference count when
 mknod fails
In-Reply-To: <201007151325.06942.tvrtko.ursulin@sophos.com>
Message-ID: <alpine.LRH.2.00.1007161138280.17085@tundra.namei.org>
References: <201007151325.06942.tvrtko.ursulin@sophos.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Tvrtko Ursulin wrote:

> 
> lookup_one_len increments dentry reference count which is not decremented
> when the create operation fails. This can cause a kernel BUG at
> fs/dcache.c:676 at unmount time. Also error code returned when new_inode()
> fails was replaced with more appropriate -ENOMEM.
> 
> 
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
