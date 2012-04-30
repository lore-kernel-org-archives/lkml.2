Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2D3FF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:05:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55620 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2D3FFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:05:55 -0400
Date: Sun, 29 Apr 2012 18:04:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Peter Chen <B29397@freescale.com>
Subject: Re: [ 39/62] EHCI: fix criterion for resuming the root hub
Message-ID: <20120430010400.GA25022@kroah.com>
References: <20120424223305.GA7748@kroah.com>
 <20120424223245.328130919@linuxfoundation.org>
 <20120425061741.GA14971@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425061741.GA14971@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 01:17:42AM -0500, Jonathan Nieder wrote:
> Hi Greg,
> 
> Greg KH wrote:
> 
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> [...]
> > commit dc75ce9d929aabeb0843a6b1a4ab320e58ba1597 upstream.
> >
> > This patch (as1542) changes the criterion ehci-hcd uses to tell when
> > it needs to resume the controller's root hub.  A resume is needed when
> > a port status change is detected, obviously, but only if the root hub
> > is currently suspended.
> 
> Here's a blind backport to 3.0-stable (for next week, perhaps) that
> accounts for the lack of v3.2-rc1~183^2~179^2~19 ("USB: EHCI: remove
> usages of hcd->state", 2011-08-18).

Applied, thanks.
