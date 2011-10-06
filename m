Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab1JFUG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:06:59 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40570 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876Ab1JFUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:06:58 -0400
X-Sasl-enc: yk1bkcKewQXVkeZVLW59ZD1q7ZRnMuxQumfV9Ipn2rEc 1317931617
Date: Thu, 6 Oct 2011 13:06:52 -0700
From: Greg KH <greg@kroah.com>
To: Valdis.Kletnieks@vt.edu
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111006200652.GA22225@kroah.com>
References: <20111006190526.GA13883@redhat.com>
 <20111006194432.GA21642@kroah.com>
 <20111006195007.GA24900@redhat.com>
 <14371.1317930822@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14371.1317930822@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 03:53:42PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 06 Oct 2011 15:50:07 EDT, Dave Jones said:
> 
> > I feel a bit dirty overloading TAINT_CRAP (even if the name is apropos).
> > Should I introduce a TAINT_OUT_OF_TREE perhaps instead ?
> 
> That would fix my biggest issue with the patch - it's a slippery slope.  But if
> we bite the bullet and go straight to the bottom of the slope with an
> OUT_OF_TREE taint, I'd be happy with that.
> 
> Is there a good way to identify at modprobe time if a module is in-tree or
> out-of-tree?

See my previous email, yes, we can do this.

greg k-h
