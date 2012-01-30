Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2A3XVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:21:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46861 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2A3XVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:21:12 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxFtsOj+9RYQGj+WEk3ovg4+d_syn8TooKjvBq2_B463Q@mail.gmail.com>
References: <20120130211241.GA12941@kroah.com> <CA+55aFxFtsOj+9RYQGj+WEk3ovg4+d_syn8TooKjvBq2_B463Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Jan 2012 15:20:52 -0800
X-Google-Sender-Auth: 9u5eLKu3V4R0DXdwy2dn5qUT7No
Message-ID: <CA+55aFxGf8-Bv8Jrhm1dbTg6AkTi37Vfuw5OOC7hDokKRa4hjw@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY/serial patches for 3.3-rc1
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 3:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Tssk. Your script is broken, or your manual fixup is broken. Look at
> the tag-name again.
>
> I pulled the correct one, but please be more careful.

Oh, and if it's because your old script can't verify the tag-names, so
you fix things up by hand instead of scripting it, try using
"tags/<tagname>" instead of just "<tagname>". That makes old git
versions at least see the reference, even if they don't then react to
the signing itself (ie they just treat it as the commit it points to,
rather than as a tag with interesting contents in itself)

                  Linus
