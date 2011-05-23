Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab1EWT2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:28:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab1EWT2b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <20110523190539.GA17519@kroah.com>
References: <20110523190539.GA17519@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 12:27:35 -0700
Message-ID: <BANLkTi=jGtVjJEY9aE2SPJCHhbpXfgsFTg@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY/serial driver patches for .40
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:05 PM, Greg KH <gregkh@suse.de> wrote:
>
> Some api cleanups, and driver updates, nothing really major.  You will
> get two conflicts when you merge this to your tree (one in the tty
> Makefile and one in the bluetooth driver), but they should be "obvious"
> as to what to do.

I went a bit beyond "obvious", and actually fixed in the merge what
looked to be some missed things:

 - the hci_uart_tty_receive "Return value" comment was stale

 - it really looked to me like the 'stat.byte_rx' increment should use
the new 'received' count that we return.

So anybody who cares should probably check the end result.

                         Linus
