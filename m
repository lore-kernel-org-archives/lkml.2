Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab0EUPQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:16:49 -0400
Received: from kroah.org ([198.145.64.141]:58738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183Ab0EUPQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:16:47 -0400
Date: Fri, 21 May 2010 08:13:23 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       therbert@google.com, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the driver-core tree with the net
 tree
Message-ID: <20100521151323.GA32573@kroah.com>
References: <20100521162134.6b6326bd.sfr@canb.auug.org.au>
 <m1tyq1wy4h.fsf@fess.ebiederm.org>
 <20100520.235008.97331614.davem@davemloft.net>
 <m1pr0pwvgk.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1pr0pwvgk.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 12:43:55AM -0700, Eric W. Biederman wrote:
> David Miller <davem@davemloft.net> writes:
> 
> > From: ebiederm@xmission.com (Eric W. Biederman)
> > Date: Thu, 20 May 2010 23:46:22 -0700
> >
> >> It looks right, except perhaps the RPS code looks like it will cause a
> >> build failure with sysfs disabled, but that has nothing to do with your
> >> changes.
> >
> > CONFIG_RPS depends upon CONFIG_SMP && CONFIG_SYSFS, so no that build
> > failure is not possible.
> 
> That's the bit I'm missing.  My apologies if I caused any unnecessary worry.

I've now fixed this all up in my tree and have pushed it out.
I'll also go push the patches themselves to Linus later today.

thanks,

greg k-h
