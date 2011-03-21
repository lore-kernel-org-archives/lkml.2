Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab1CUXji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:39:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541Ab1CUXjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:39:35 -0400
Date: Mon, 21 Mar 2011 16:38:53 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timo Warns <warns@pre-sense.de>
Subject: Re: [10/87] Fix corrupted OSF partition table parsing
Message-ID: <20110321233853.GA6599@suse.de>
References: <20110321230732.GA26510@kroah.com>
 <20110321230710.202271726@clark.kroah.org>
 <AANLkTikFsGPHgx=B+ZuCjq82TgO1143rW_U5DNCQRyH-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikFsGPHgx=B+ZuCjq82TgO1143rW_U5DNCQRyH-@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 04:22:11PM -0700, Linus Torvalds wrote:
> On Mon, Mar 21, 2011 at 4:06 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > commit 1eafbfeb7bdf59cfe173304c76188f3fd5f1fd05 upstream.
> 
> This needs commit 34d211a2d5df4984a35b18d8ccacbe1d10abb067 as well.
> 
> Maybe it's there in your list, but it hasn't arrived in my mailbox yet.

Yes, it's in there, it's patch 30/87 in the series.

thanks for checking.

greg k-h
