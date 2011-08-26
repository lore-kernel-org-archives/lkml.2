Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1HZWfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:35:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43459 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab1HZWfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:35:36 -0400
X-Sasl-enc: Ut8IWdEPjKdAVU2VXX23CkRgsvQM+0TQTGHK4i8OU850 1314398136
Date: Fri, 26 Aug 2011 15:35:19 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Message-ID: <20110826223519.GA22607@kroah.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
 <20110826214329.GA6325@kroah.com>
 <20110826222544.GV25996@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826222544.GV25996@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 12:25:44AM +0200, Andi Kleen wrote:
> > > wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
> > > gcc -o uname26 uname26.c
> > > ./uname26 program
> > 
> > I hate to ask, but can you put a proper copyright and license on this
> > file so that distros can distribute it?
> 
> I assumed it's too trivial for that.

Lawyers never assume that :)

> Anyways I put a GPL license on it now.

Thanks, much appreciated.

greg k-h
