Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0HNAsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:48:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:52788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab0HNAsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:48:02 -0400
Date: Fri, 13 Aug 2010 17:47:29 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [0/3] 2.6.27.52 stable review
Message-ID: <20100814004729.GA3695@suse.de>
References: <20100813214704.GA18960@kroah.com>
 <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
 <20100813230712.GA1703@suse.de>
 <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com>
 <AANLkTimruyaAB-raY2ywqPQSR-h+yp7tME=eTKngcMQm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimruyaAB-raY2ywqPQSR-h+yp7tME=eTKngcMQm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 05:12:57PM -0700, Linus Torvalds wrote:
> On Fri, Aug 13, 2010 at 4:47 PM, Grant Coady <gcoady.lk@gmail.com> wrote:
> >
> > Machine is running, but there's a lot of these in the dmesg:
> >
> > WARNING: at include/linux/security.h:1826 acct_stack_growth+0xe7/0xf0()
> 
> That would seem to be because of the lack of commit 05fa199d45c in
> 2.6.27. It got marked for stable, but probably never went so far back
> as 2.6.27.

Yup, I didn't include it there.  Grant, if you add that, does the
warning go away?

> That said, I do wonder if it is worth it maintaining a 2.6.27 that the
> maintainer can't even boot on his machines any more.

Yeah, I'm beginning to wonder about it as well.  I think it's expected
lifespan is very near to the end.

thanks,

greg k-h
