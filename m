Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab1EOQwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:52:34 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:52454 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab1EOQwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:52:33 -0400
X-Originating-Ip: 216.16.235.2
Date: Sun, 15 May 2011 12:49:21 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Greg KH <greg@kroah.com>
Cc: matt mooney <mfmooney@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] staging: usbip: add userspace code
Message-ID: <20110515164921.GA4060@foursquare.net>
References: <cover.1305369175.git.mfm@muteddisk.com> <7dce7775af890105a685b67408f38fbef99cbdfe.1305369176.git.mfm@muteddisk.com> <20110515034608.GA8484@foursquare.net> <20110515162950.GD1315@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515162950.GD1315@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 09:29:50AM -0700, Greg KH wrote:
> Are these in the "real" usb.ids file?  If not, care to enter them in on
> the linux-usb.org site so we can sync up there?
> 
> This file will be removed from the in-kernel tree as soon as possible,
> it's just there as part of the original import of the usbip userspace
> tools.  No one should ever have to have 2 copies of this file on their
> system, that's madness.

Thanks.  I didn't realize there was a master copy.

I checked linux-usb.org and the extra IDs are already there.

- Chris

