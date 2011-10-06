Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab1JFUdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:33:11 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45455 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682Ab1JFUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:33:09 -0400
X-Sasl-enc: kGheG8yx6ABfsqKGr+/iXA/B5lxr+qUse92CAyYcRCwU 1317933188
Date: Thu, 6 Oct 2011 13:30:34 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111006203034.GA22362@kroah.com>
References: <20111006190526.GA13883@redhat.com>
 <20111006194432.GA21642@kroah.com>
 <20111006195007.GA24900@redhat.com>
 <20111006195824.GA22033@kroah.com>
 <20111006200440.GB25681@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006200440.GB25681@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 04:04:40PM -0400, Dave Jones wrote:
> On Thu, Oct 06, 2011 at 12:58:24PM -0700, Greg Kroah-Hartman wrote:
> 
>  > > I feel a bit dirty overloading TAINT_CRAP (even if the name is apropos).
>  > > Should I introduce a TAINT_OUT_OF_TREE perhaps instead ?
>  > 
>  > We could do that in a "generic" way by setting a "in-tree" flag type
>  > thing for everything that is built from within the kernel build, and
>  > then taint if that flag is not found.
> 
> what stops an out of tree module from setting that flag ?
> I guess I need to see the implementation to understand this.

If an out of tree module wants to override this, they can do so pretty
easily, it's not the gpg-sign type thing that RHEL did.

So as it is pretty easy to get around, I supposed all out-of-tree
modules would eventually just figure out how to set it because people
would complain.  But then again, virtual box could just rename their
module, which would do the same thing here.

I guess it all depends on how "hard" we want to try to enforce this.

greg k-h
