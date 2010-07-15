Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab0GORLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:11:49 -0400
Received: from kroah.org ([198.145.64.141]:51586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757Ab0GORLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:11:46 -0400
Date: Thu, 15 Jul 2010 10:10:51 -0700
From: Greg KH <greg@kroah.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH][securityfs][2.6.34] Drop dentry reference count when
	mknod fails
Message-ID: <20100715171051.GA21798@kroah.com>
References: <201007151325.06942.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007151325.06942.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 01:25:06PM +0100, Tvrtko Ursulin wrote:
> 
> lookup_one_len increments dentry reference count which is not decremented
> when the create operation fails. This can cause a kernel BUG at
> fs/dcache.c:676 at unmount time. Also error code returned when new_inode()
> fails was replaced with more appropriate -ENOMEM.
> 

Nice, thanks for finding and fixing this, great job.

> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
