Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2EEA3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 20:29:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab2EEA3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 20:29:20 -0400
Date: Fri, 4 May 2012 17:29:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Timo Warns <warns@pre-sense.de>,
        WANG Cong <amwang@redhat.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Miklos Szeredi <mszeredi@suse.cz>, Sage Weil <sage@newdream.net>,
        Eugene Teo <eteo@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Anderson <anderson@redhat.com>, stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hfsplus: Fix potential buffer overflows
Message-ID: <20120505002917.GA28388@kroah.com>
References: <20120504190939.GA12976@kroah.com>
 <CA+55aFxuqi5e_zNFUddmtOXfA5hBFfL4weEYG9NdRx9UKhP6ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxuqi5e_zNFUddmtOXfA5hBFfL4weEYG9NdRx9UKhP6ZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 04:53:47PM -0700, Linus Torvalds wrote:
> On Fri, May 4, 2012 at 12:09 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Reported-by: Timo Warns <warns@pre-sense.de>
> > Cc: WANG Cong <amwang@redhat.com>
> 
> Tssk. You got an ack at least from Cong.

Oops, you are right, sorry.

> > Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
> > Cc: Cong Wang <amwang@redhat.com>
> 
> .. who you have listed twice with just a cc.

Ugh, my fault, sorry.

greg k-h
