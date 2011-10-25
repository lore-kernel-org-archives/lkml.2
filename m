Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1JYCTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:19:09 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41368 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212Ab1JYCTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:19:06 -0400
X-Sasl-enc: svZV1MLQ73MTbSOv29rGDRXEodE25NGfwUb3QSkIv45R 1319509146
Date: Tue, 25 Oct 2011 03:37:34 +0200
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111025013734.GA22764@kroah.com>
References: <1319461948.31243.31.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319461948.31243.31.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 03:12:28PM +0200, Ben Hutchings wrote:
> Use of the GPL or a compatible licence doesn't necessarily make the code
> any good.  We already consider staging modules to be suspect, and this
> should also be true for out-of-tree modules which may receive very
> little review.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> Debian has been carrying this for the last few kernel versions.  The
> recent thread '[RFC] virtualbox tainting.' and discussions at KS suggest
> that this might be more generally useful.

Wonderful, thanks for pushing this:

	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>


