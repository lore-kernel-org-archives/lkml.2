Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1J2Gia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 02:38:30 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51191 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398Ab1J2Gi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 02:38:29 -0400
X-Sasl-enc: IlI8YX79ZAIviBE5H3VSWxFTk9ERZb7W5hOkhZ+ukEUv 1319870308
Date: Sat, 29 Oct 2011 08:38:09 +0200
From: Greg KH <greg@kroah.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] uio: allow drivers to override the pgprot for
 mmap
Message-ID: <20111029063809.GC2280@kroah.com>
References: <1319817030-23992-1-git-send-email-galak@kernel.crashing.org>
 <20111028214812.GD23092@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028214812.GD23092@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 11:48:12PM +0200, Hans J. Koch wrote:
> On Fri, Oct 28, 2011 at 10:50:29AM -0500, Kumar Gala wrote:
> > For some devices, the default behavior of pgprot_noncached() is not
> > appropriate for all of its mappable regions. This provides a means for
> > the kernel side of the UIO driver to override the flags without having
> > to implement its own full mmap callback.
> 
> Thanks for also providing an example driver showing the use of this.
> You should also post this driver in a mainline-ready version, I'm a bit
> uncomfortable with adding a new function pointer without having any users.

I'm more than "uncomfortable", I'll refuse to take any such patch unless
there is a in-kernel user, otherwise it makes no sense to add the
pointer at all.

thanks,

greg k-h
