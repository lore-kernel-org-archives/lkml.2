Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2FOH6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:58:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:22897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab2FOH6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:58:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165976508"
Date: Fri, 15 Jun 2012 15:58:10 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@freedesktop.org>,
        Linus Torvalds <torvalds@ppc970.osdl.org>
Subject: Re: automated warning notifications
Message-ID: <20120615075810.GA13206@localhost>
References: <20120614172523.GB4400@mwanda>
 <20120615014835.GA5695@localhost>
 <20120615071222.GZ13539@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615071222.GZ13539@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC sparse developers]

// on setting up a list and sending newly found sparse warnings to it

On Fri, Jun 15, 2012 at 10:12:22AM +0300, Dan Carpenter wrote:
> On Fri, Jun 15, 2012 at 09:48:35AM +0800, Fengguang Wu wrote:
> > The lots of false warnings are a big problem. It makes the automated
> > notification more noises than signals to people. So I end up disabling
> > the sparse check totally..
> > 
> 
> I do a basic sanity check of my emails before I send them.

Yeah that would be better.

> Sometimes I do send false positives.  If the warning is introduced
> by a very new code then probably the patch author can answer my
> question off the top of her head.  Also I send some false positives
> just to try learn what the rules are.

Heh.

> > In an average working day, 1-2 build errors will be caught and email
> > notified. I guess there will be more sparse warnings if it's turned
> > on.
> > 
> > Perhaps the sparse warnings can be enabled, but only sent to the patch
> > author. If you and anyone else are interested, they could be sent to
> > some mailing list, too. One thing I'm sure is, we probably never want
> > to disturb the busy maintainers with these warnings.
> 
> Eventually I think we will want to set up a mailing list for this or
> we will start sending duplicate messages.

Fair enough. How can we setup the mailing list? Once the list up, it
would be trivial for me to send sparse warnings out there.

Thanks,
Fengguang
