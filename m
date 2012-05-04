Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679Ab2EDXyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:54:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47236 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2EDXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:54:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120504190939.GA12976@kroah.com>
References: <20120504190939.GA12976@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 May 2012 16:53:47 -0700
X-Google-Sender-Auth: wbmVrUWZzzQtsSyPPxQiyZ0HN7o
Message-ID: <CA+55aFxuqi5e_zNFUddmtOXfA5hBFfL4weEYG9NdRx9UKhP6ZQ@mail.gmail.com>
Subject: Re: [PATCH] hfsplus: Fix potential buffer overflows
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Timo Warns <warns@pre-sense.de>,
        WANG Cong <amwang@redhat.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Miklos Szeredi <mszeredi@suse.cz>, Sage Weil <sage@newdream.net>,
        Eugene Teo <eteo@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Anderson <anderson@redhat.com>, stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 12:09 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Reported-by: Timo Warns <warns@pre-sense.de>
> Cc: WANG Cong <amwang@redhat.com>

Tssk. You got an ack at least from Cong.

> Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Cc: Cong Wang <amwang@redhat.com>

.. who you have listed twice with just a cc.

                      Linus
