Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1DSUaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:30:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50168 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab1DSUaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:30:19 -0400
Date: Tue, 19 Apr 2011 21:29:22 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Greg KH <greg@kroah.com>
cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] char: agp: fix OOM and buffer overflow
In-Reply-To: <20110419181013.GA12437@kroah.com>
Message-ID: <alpine.DEB.2.00.1104192127170.31867@skynet.skynet.ie>
References: <1302800120-31560-1-git-send-email-segoon@openwall.com> <20110419162157.GD23196@kroah.com> <20110419174813.GA27544@albatros> <20110419181013.GA12437@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Apr 19, 2011 at 09:48:13PM +0400, Vasiliy Kulikov wrote:
> > On Tue, Apr 19, 2011 at 09:21 -0700, Greg KH wrote:
> > > David, what ever happened to this, and the other agp bugfix from
> > > Vasiliy?
> > 
> > I got emails that both fixes went into -mm.
> 
> That's good, but David needs to take them and push them to Linus...
> 
> 

I'm ruminating, while they are security fixes, I'm hesitant to push them 
ASAP, without further testing, the /dev/agpgart hasn't really been used
by much in around 5 years, so getting a userspace and hardware that can 
test it is quite a lot of fun, though I suppse on the other side, nobody 
will notice if it breaks anything for 2 years.

Dave.
