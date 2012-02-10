Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2BJP1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:27:11 -0500
Received: from broadrack.ru ([195.178.208.66]:35510 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754540Ab2BJP1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:27:09 -0500
Date: Fri, 10 Feb 2012 18:23:16 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Valdis.Kletnieks@vt.edu
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: pohmelfs: call for inclusion
Message-ID: <20120210152316.GA16913@ioremap.net>
References: <20120208193413.GA22215@ioremap.net>
 <20120208201008.GA5578@kroah.com>
 <20120208201254.GD22215@ioremap.net>
 <4792.1328835255@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4792.1328835255@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 07:54:15PM -0500, Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> > +	tristate "POHMELFS distributed filesystem"
> > +	depends on INET && EXPERIMENTAL
> > +	select CRYPTO_HASH
> > +	help
> > +	  POHMELFS is a POSIX frontend to Elliptics network
> > +
> > +	  Elliptics is a key/value storage, which by default imlpements
> typo fix:			implements
> > +	  distributed hash table structure.

Fixed, thank you :)

-- 
	Evgeniy Polyakov
