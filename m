Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1AGWpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:45:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147Ab1AGWpX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:45:23 -0500
MIME-Version: 1.0
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Jan 2011 14:44:14 -0800
Message-ID: <AANLkTi=mCKWKTcP7JVdwVkk4OVEGDNHYgb5-W+1NJmtQ@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY/serial merge for .38
To: Greg KH <gregkh@suse.de>, Daniel Hellstrom <daniel@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 1:54 PM, Greg KH <gregkh@suse.de> wrote:
> Here is the big tty and serial merge for .38.  I'll be sending another
> smaller one that just moves drivers around after .38-rc1 is out, as is
> the norm for file moves to handle issues with other trees syncing up
> properly.

Merged. However, the drivers/serial/apbuart.c file conflicted, and
both sides of the merge had some insanity in them.

So I did an "evil merge" - a merge that actually changed the code to
match neither side - and it looks better to me. But maybe that's just
the drugs I'm taking talking.

So people should check it out. In particular, look at the interaction
of "drivers: serial: apbuart: Handle OF failures gracefully" and the
"Added support for ampopts in APBUART driver. Used in AMP systems"
commit.

                    Linus
