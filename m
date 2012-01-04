Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2ADAc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:32:26 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51715 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316Ab2ADAcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:32:23 -0500
X-Sasl-enc: s7EELm0xesNmqRL+HTiORByFkZ+9wefL23dYJ97Gqzcv 1325637142
Date: Tue, 3 Jan 2012 16:31:16 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20120104003116.GC22350@kroah.com>
References: <20111228174518.721624fad9d048f9f85b3d50@canb.auug.org.au>
 <20120103162108.GC25909@kroah.com>
 <CAPXgP11yiS5hF9q3+A1tyORmtp=z2T6CWBUDFh3FhcL19jADpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP11yiS5hF9q3+A1tyORmtp=z2T6CWBUDFh3FhcL19jADpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 01:07:52AM +0100, Kay Sievers wrote:
> On Tue, Jan 3, 2012 at 17:21, Greg KH <greg@kroah.com> wrote:
> > On Wed, Dec 28, 2011 at 05:45:18PM +1100, Stephen Rothwell wrote:
> >> Because of the powerpc problems above, I have used the driver-core tree
> >> from next-20111222 for today.
> >
> > Sorry about all of the problems, we tried to fix everything we could,
> > but your merges and cross-builds found stuff we missed :(
> >
> > Kay, care to send me patches to fix this, and all of the other
> > linux-next-reported problems to me so we can get this resolved this
> > week?
> 
> I rather don't want to add error checking to stuff that doesn't do it
> today. The sysdev stuff never had that forced checks, but the normal
> device stuff has.

That's fine.

> I think the force return value check is really a pretty misguided idea
> in general, and it's up to the caller to do these checks and handle
> rollbacks, not the driver core, I think.
> 
> Can't we just remove that forced check?

Probably, if it fixes these warning-is-an-error problems.  There were
other issues with linux-next that were build issues, not just this one
from what I recall, that kept Stephen from including the tree in
linux-next.  I can bounce them to you if you missed them.

thanks,

greg k-h
