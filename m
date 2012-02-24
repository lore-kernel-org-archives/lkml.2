Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2BXSVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:21:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65291 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2BXSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:21:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.102.132 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1202241859160.31150@pobox.suse.cz>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <alpine.LRH.2.00.1202241112350.22368@twin.jikos.cz> <CA+55aFwg4EpUhbymOHrSt88FEmZWniMx4goCkk-xK7dwiKcsZg@mail.gmail.com>
 <alpine.LNX.2.00.1202241859160.31150@pobox.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Feb 2012 10:21:11 -0800
X-Google-Sender-Auth: MUYm2ODWfuotjYv4Pn6KxPz1FWU
Message-ID: <CA+55aFzN8jepYdLOoX35OrKt_oHaLzJ6AL11D3Gc2iJAZE+Kuw@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:01 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> On the other hand I wouldn't blame HW for a bit-flip, as it was a clear
> NULL pointer (plus 0x30 offset), not a random garbage.

Agreed. Actual NULL pointers tend to be us screwing things up.

                    Linus
