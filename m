Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab0JGC6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 22:58:11 -0400
Received: from kroah.org ([198.145.64.141]:35571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0JGC6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 22:58:10 -0400
Date: Wed, 6 Oct 2010 19:55:42 -0700
From: Greg KH <greg@kroah.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [stable] [PATCH v2] ipc: initialize structure memory to zero
	for shmctl
Message-ID: <20101007025542.GA10460@kroah.com>
References: <20101007021836.GA14666@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007021836.GA14666@outflux.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 07:18:36PM -0700, Kees Cook wrote:
> The old shm interface will leak a few bytes of stack contents. Explicitly
> initialize the structure to zero-fill the untouched fields, using memset
> instead of C99-style in case there are ever holes in the structure.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---

If you wish to have a patch included in the stable series, please read
Documentation/stable_kernel_rules.txt which state that adding a:
	Cc: stable <stable@kernel.org>
to the signed-off-by: area will cause it to be automagically included
when the patch gets into Linus's tree.  Otherwise it just causes a lot
of extra work for me to dig around and watch out for it in the future.

thanks,

greg k-h
