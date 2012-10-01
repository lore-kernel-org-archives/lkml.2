Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2JASRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:17:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37749 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab2JASRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:17:41 -0400
X-Sasl-enc: bPGe55M1CuQFejY2cz8E09WqJ0og40aG2HFVhCr+ySI4 1349115460
Date: Mon, 1 Oct 2012 11:17:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: no diffstat for 'git request-pull' (was Re: [GIT PATCH]
 char/misc changes for 3.7-rc1)
Message-ID: <20121001181739.GA10827@kroah.com>
References: <20121001175433.GA10092@kroah.com>
 <20121001175711.GB10092@kroah.com>
 <201210011803.48211.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210011803.48211.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 06:03:47PM +0000, Arnd Bergmann wrote:
> On Monday 01 October 2012, Greg KH wrote:
> > Wait, what happened to the diffstat?  Does the latest version of git not
> > send out the diffstat for 'git request-pull'?  It used to on older
> > versions, I just updated the version on my machine that generated this
> > to
> >         git version 1.7.12.2.421.g261b511
> > 
> > Do I have to give a new option to request-pull to have the diffstat show
> > up?  I'm using
> >         git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ char-misc-3.6
> > 
> > For this specific request pull.
> 
> It looks more like you just sent an empty pull request from v3.6-rc3 to 
> v3.6-rc3 (fea7a08acb135).

Ah crap, you are right, totally my fault.

I'll blame it on being Monday morning...

sorry for the noise...

greg k-h
