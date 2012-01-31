Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2AaA1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:27:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50987 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2AaA1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:27:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120131001308.GB20588@suse.de>
References: <20120130211241.GA12941@kroah.com> <CA+55aFxFtsOj+9RYQGj+WEk3ovg4+d_syn8TooKjvBq2_B463Q@mail.gmail.com>
 <CA+55aFxGf8-Bv8Jrhm1dbTg6AkTi37Vfuw5OOC7hDokKRa4hjw@mail.gmail.com> <20120131001308.GB20588@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Jan 2012 16:27:22 -0800
X-Google-Sender-Auth: 9bHR0bpHtWNfudv-r_wOt8e3-I0
Message-ID: <CA+55aFxXwZmhC4USJSOk_itatwkg1m8gkQRTqKHNRGDWD8MCOw@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY/serial patches for 3.3-rc1
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 4:13 PM, Greg KH <gregkh@suse.de> wrote:
>
> Or I can spend the time to get the new version of git installed.
> Wrestling with my scripts or rpm, I don't know which is worse...

Why do either?

The sane way to do things is to just

    cd
    mkdir src
    cd src
    git clone git://github.com/gitster/git
    cd git
    make
    make install

all as a regular user. It will install in your $(HOME)/bin, so just
put that first in the path. No need to fight rpm, no need to fight
your scripts, you should be pretty much all done.

                 Linus
