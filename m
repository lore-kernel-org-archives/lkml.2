Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2CEWej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:34:39 -0500
Received: from 1wt.eu ([62.212.114.60]:62887 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024Ab2CEWei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:34:38 -0500
Date: Mon, 5 Mar 2012 23:33:38 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
Message-ID: <20120305223338.GE2930@1wt.eu>
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz> <20120305120241.GA3627@osiris.boeblingen.de.ibm.com> <4F54B618.1090301@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54B618.1090301@suse.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 05, 2012 at 01:48:24PM +0100, Jiri Slaby wrote:
> >>> Linus Torvalds (2): Fix autofs compile without CONFIG_COMPAT
> >>
> >> But who defines is_compat_task *with* CONFIG_COMPAT on ia64?
> >>
> >> fs/autofs4/inode.c: In function 'autofs4_fill_super':
> >> fs/autofs4/inode.c:345: error: implicit declaration of function
> >> 'is_compat_task'
> > 
> > The ia64 compat code got entirely removed, since it was broken:
> > 
> > 32974ad4907cdde6c9de612cd1b2ee0568fb9409 "[IA64] Remove COMPAT_IA32 support"
> 
> Yes, but that is even in 2.6.34. So the fix for autofs is incomplete in
> .32 as it breaks build on configs which used to work.

So in the end, does anybody have an idea what is missing from this patch ?
I'm not sure that reverting the autofs fix is a right solution either :-/

Thanks,
Willy

