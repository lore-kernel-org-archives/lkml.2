Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1DSQtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:49:03 -0400
Received: from kroah.org ([198.145.64.141]:59746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1DSQtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:49:01 -0400
Date: Tue, 19 Apr 2011 09:10:24 -0700
From: Greg KH <greg@kroah.com>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org,
        Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [stable] Linux 2.6.32.37
Message-ID: <20110419161024.GA23196@kroah.com>
References: <20110415164914.GA10357@kroah.com>
 <alpine.DEB.2.02.1104152256340.7559@aurora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1104152256340.7559@aurora>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 11:00:45PM +0200, Sven-Haegar Koch wrote:
> On Fri, 15 Apr 2011, Greg KH wrote:
> 
> > I'm announcing the release of the 2.6.32.37 kernel.
> 
> > Vasiliy Kulikov (13):
> >       net: ax25: fix information leak to userland
> 
> 2.6.32.37 contains fe10ae53384e48c51996941b7720ee16995cbcb7, but seems 
> to miss 5b919f833d9d60588d026ad82d17f17e8872c7a9 which fixes this fix.
> 
> (Found by checking why Ubuntu had a different fix here than 2.6.32.37)

Thanks, I've queued this up as well now.

greg k-h
