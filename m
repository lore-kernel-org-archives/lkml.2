Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1HZWZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:25:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53119 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1HZWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:25:49 -0400
Date: Sat, 27 Aug 2011 00:25:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Message-ID: <20110826222544.GV25996@one.firstfloor.org>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <20110826214329.GA6325@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826214329.GA6325@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
> > gcc -o uname26 uname26.c
> > ./uname26 program
> 
> I hate to ask, but can you put a proper copyright and license on this
> file so that distros can distribute it?

I assumed it's too trivial for that.

Anyways I put a GPL license on it now.

-Andi
