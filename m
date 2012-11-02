Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2KBW0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:26:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52463 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2KBW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:26:44 -0400
MIME-Version: 1.0
In-Reply-To: <2471412.ilAVQkroSv@vostro.rjw.lan>
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com>
 <CAKMK7uENP_XWQ7UWjd+PnqTH-S-jYRjrnfY1TwocfbT6abL61w@mail.gmail.com>
 <1490901.1Nt8OOcfdR@vostro.rjw.lan> <2471412.ilAVQkroSv@vostro.rjw.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Nov 2012 15:26:22 -0700
X-Google-Sender-Auth: JC8HKP98_U5eq7ysrOFgGjmlm-E
Message-ID: <CA+55aFzfbvb4HsY0viCXC0FnVt7fcyhzyZgR4R6tu5uYC8qzPA@mail.gmail.com>
Subject: Re: Linux 3.7-rc3
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Michal Hocko <mhocko@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 3:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Well, it appears that Tumbleweed has acquired a broken s2disk binary.
> Replace it with one built from upstream sources and it magically starts to
> work. Grumble.
>
> Sorry for the noise.

Heh. This was the report that so far made me most worried about the
current state of the -rc process, so I'll curse you and be very
relieved at the same time ;)

                Linus
