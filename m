Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0LFEFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 23:05:54 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39281 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331Ab0LFEFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 23:05:53 -0500
X-Sasl-enc: WLQ5PgtGW5cxPRcIk9FD8HUqhuAGpxU2lCkrWWx7Mybq 1291608352
Subject: Re: [PATCH] autofs4 - remove ioctl mutex
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        autofs mailing list <autofs@linux.kernel.org>
In-Reply-To: <AANLkTinaxtTZzWymJfXv2=HBgya2MJ3m21myjMZQ_rxT@mail.gmail.com>
References: <20101206035123.28966.79954.stgit@localhost6.localdomain6>
	 <AANLkTinaxtTZzWymJfXv2=HBgya2MJ3m21myjMZQ_rxT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 12:05:46 +0800
Message-ID: <1291608346.9376.7.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-05 at 19:55 -0800, Linus Torvalds wrote:
> On Sun, Dec 5, 2010 at 7:51 PM, Ian Kent <raven@themaw.net> wrote:
> > With the recent changes to remove the BKL a mutex was added to the
> > ioctl entry point for calls to the old ioctl interface. This mutex
> > needs to be removed because of the need for the expire ioctl to call
> > back to the daemon to perform a umount and receive a completion
> > status (via another ioctl).
> >
> > This should be fine as the new ioctl interface uses much of the same
> > code and it has been used without a mutex for around a year without
> > issue, as was the original intention.
> 
> Sign-off?

Oops, sorry.
Would you like me to re-send after asking those concerned if I can add
their sign-off, and adding mine of course?

Ian


