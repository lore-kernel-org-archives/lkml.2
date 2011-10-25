Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1JYUFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:05:31 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52850 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab1JYUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:05:30 -0400
X-Sasl-enc: d/VY4QCLghkCyiCQK9dPLrYfZONZN6dsLNbDqWLbe5D4 1319573129
Date: Tue, 25 Oct 2011 22:04:55 +0200
From: Greg KH <greg@kroah.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111025200455.GA6376@kroah.com>
References: <1319461948.31243.31.camel@deadeye>
 <4EA57CBF.2050901@xenotime.net>
 <87k47tpvvm.fsf@rustcorp.com.au>
 <20111025153855.GA24779@elliptictech.com>
 <1319558749.11727.6.camel@deadeye>
 <20111025165142.GA25354@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025165142.GA25354@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:51:42PM -0400, Nick Bowler wrote:
> On 2011-10-25 18:05 +0200, Ben Hutchings wrote:
> > On Tue, 2011-10-25 at 11:38 -0400, Nick Bowler wrote:
> > > This patch prevents the use of lockdep for debugging out of tree
> > > modules, which is rather mean.
> > 
> > It was already disabled for staging modules, which seems equally
> > unhelpful.
> 
> This is not the case: lockdep works fine with staging modules.

Yes, that was fixed a few kernel versions ago.

Now you might want to update that fix for the TAINT_OOT_MODULE flag as
well, if you feel it is needed.

greg k-h
