Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab1EWTmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:42:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:43486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab1EWTmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:42:05 -0400
Date: Mon, 23 May 2011 12:43:06 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/serial driver patches for .40
Message-ID: <20110523194306.GA20850@suse.de>
References: <20110523190539.GA17519@kroah.com>
 <BANLkTi=jGtVjJEY9aE2SPJCHhbpXfgsFTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=jGtVjJEY9aE2SPJCHhbpXfgsFTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:27:35PM -0700, Linus Torvalds wrote:
> On Mon, May 23, 2011 at 12:05 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > Some api cleanups, and driver updates, nothing really major.  You will
> > get two conflicts when you merge this to your tree (one in the tty
> > Makefile and one in the bluetooth driver), but they should be "obvious"
> > as to what to do.
> 
> I went a bit beyond "obvious", and actually fixed in the merge what
> looked to be some missed things:
> 
>  - the hci_uart_tty_receive "Return value" comment was stale
> 
>  - it really looked to me like the 'stat.byte_rx' increment should use
> the new 'received' count that we return.
> 
> So anybody who cares should probably check the end result.

It looks correct to me, thanks for catching this and doing the merge.

greg k-h
