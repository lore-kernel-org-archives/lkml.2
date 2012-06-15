Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2FOIbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:31:14 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52063 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2FOIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:31:09 -0400
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 01:31:00 -0700
From: Josh Triplett <josh@freedesktop.org>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
        Linus Torvalds <torvalds@ppc970.osdl.org>
Subject: Re: automated warning notifications
Message-ID: <20120615083100.GA29692@leaf>
References: <20120614172523.GB4400@mwanda>
 <20120615014835.GA5695@localhost>
 <20120615071222.GZ13539@mwanda>
 <20120615075810.GA13206@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615075810.GA13206@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 03:58:10PM +0800, Fengguang Wu wrote:
> On Fri, Jun 15, 2012 at 10:12:22AM +0300, Dan Carpenter wrote:
> > On Fri, Jun 15, 2012 at 09:48:35AM +0800, Fengguang Wu wrote:
> > > In an average working day, 1-2 build errors will be caught and email
> > > notified. I guess there will be more sparse warnings if it's turned
> > > on.
> > > 
> > > Perhaps the sparse warnings can be enabled, but only sent to the patch
> > > author. If you and anyone else are interested, they could be sent to
> > > some mailing list, too. One thing I'm sure is, we probably never want
> > > to disturb the busy maintainers with these warnings.
> > 
> > Eventually I think we will want to set up a mailing list for this or
> > we will start sending duplicate messages.
> 
> Fair enough. How can we setup the mailing list? Once the list up, it
> would be trivial for me to send sparse warnings out there.

Rather than a mailing list, how about something like test.kernel.org for
sparse warnings?

- Josh Triplett
