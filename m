Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab2JGOjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 10:39:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33254 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2JGOjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 10:39:14 -0400
Date: Sun, 7 Oct 2012 07:39:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Elric Fu <elricfu1@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Miroslav Sabljic <miroslav.sabljic@avl.com>
Subject: Re: [ 28/52] xHCI: add cmd_ring_state
Message-ID: <20121007143910.GA18016@kroah.com>
References: <20121004210635.372689554@linuxfoundation.org>
 <20121004210638.880914187@linuxfoundation.org>
 <1349571292.16173.78.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349571292.16173.78.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 01:54:52AM +0100, Ben Hutchings wrote:
> On Thu, 2012-10-04 at 14:21 -0700, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Elric Fu <elricfu1@gmail.com>
> > 
> > commit c181bc5b5d5c79b71203cd10cef97f802fb6f9c1 upstream.
> > 
> > Adding cmd_ring_state for command ring. It helps to verify
> > the current command ring state for controlling the command
> > ring operations.
> > 
> > This patch should be backported to kernels as old as 3.0.  The commit
> 
> I assume this still needs backporting for 3.0, since it wasn't included
> in 3.0.45-rc1.

Yes, there were also other xhci patches that failed to either apply, or
build, on 3.0 that were requested to be backported to there.

greg k-h
