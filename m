Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab1JYL44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:56:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab1JYL4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:56:54 -0400
Date: Tue, 25 Oct 2011 13:56:34 +0200
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mikulas Patocka <mpatocka@redhat.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20111025115634.GA12128@suse.de>
References: <20111025.063206.2273357152859701628.davem@davemloft.net>
 <CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 01:46:11PM +0200, Linus Torvalds wrote:
> Greg - please fix your crazy tools. Look at this:
> 
>    git log fs/sysfs/dir.c
> 
> and tell me why the f*&% you have commit messages like this:
> 
>   commit 4f72c0cab40536a0be501d85ea4918467ab82ad5
>   Author: Mikulas Patocka <mpatocka@redhat.com>
>   Date:   Mon Jul 25 17:55:57 2011 -0400
> 
>       sysfs: use rb-tree for name lookups
> 
>       sysfs: use rb-tree for name lookups

The "crazy" tool was using 'git am'.  The problem was that I missed the
fact that the first line of the patch sent to me duplicated the subject
line.  It's a really common problem when people generate patches and
send them off by email, I just forgot to edit the patches from Mikulas
to remove them, my fault, sorry.

greg k-h
