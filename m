Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab0JSVP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:15:27 -0400
Received: from kroah.org ([198.145.64.141]:42110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab0JSVP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:15:26 -0400
Date: Tue, 19 Oct 2010 14:14:48 -0700
From: Greg KH <greg@kroah.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH v4 00/10] xen: initial domain support
Message-ID: <20101019211448.GA10109@kroah.com>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:16:31PM +0100, Stefano Stabellini wrote:
> Hi all,
> this series implements the basic support needed to boot Linux as initial
> domain on Xen: the target is not to add full featured dom0 support in
> the kernel but to be able to boot Linux on Xen on native.

Nice, but what real use is this?

I thought people wanted dom0 support, this doesn't seem to give them
that.  Is that still the end-goal here, and this is merely a
stepping-stone to get there?

curious,

greg k-h
