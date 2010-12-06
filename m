Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0LFD4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:56:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231Ab0LFD4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:56:10 -0500
MIME-Version: 1.0
In-Reply-To: <20101206035123.28966.79954.stgit@localhost6.localdomain6>
References: <20101206035123.28966.79954.stgit@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 Dec 2010 19:55:17 -0800
Message-ID: <AANLkTinaxtTZzWymJfXv2=HBgya2MJ3m21myjMZQ_rxT@mail.gmail.com>
Subject: Re: [PATCH] autofs4 - remove ioctl mutex
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        autofs mailing list <autofs@linux.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 7:51 PM, Ian Kent <raven@themaw.net> wrote:
> With the recent changes to remove the BKL a mutex was added to the
> ioctl entry point for calls to the old ioctl interface. This mutex
> needs to be removed because of the need for the expire ioctl to call
> back to the daemon to perform a umount and receive a completion
> status (via another ioctl).
>
> This should be fine as the new ioctl interface uses much of the same
> code and it has been used without a mutex for around a year without
> issue, as was the original intention.

Sign-off?

                   Linus
