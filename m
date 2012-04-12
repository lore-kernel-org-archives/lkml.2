Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928Ab2DLDAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:00:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49723 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462Ab2DLDAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:00:50 -0400
X-Sasl-enc: xl2Mx6IjirG3/TyDdbzXe0zNwBfr87Y6d1cagt7rH0RH 1334199649
Date: Wed, 11 Apr 2012 20:00:44 -0700
From: Greg KH <greg@kroah.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Aneesh V <aneesh@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        mgreer@animalcreek.com, msalter@redhat.com
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Message-ID: <20120412030044.GA26236@kroah.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 08:44:39PM -0600, Paul Walmsley wrote:
> Cc Mark Greer, Mark Salter
> 
> Hi Greg, Aneesh,
> 
> On Sat, 17 Mar 2012, Aneesh V wrote:
> 
> > Add a driver for the EMIF SDRAM controller used in TI SoCs
> > 
> > EMIF is an SDRAM controller that supports, based on its revision,
> > one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
> > for LPDDR2.
> 
> Just checking to see what the current state of this series is.  Greg, are 
> you considering this for merging, or are there remaining issues?  Aneesh, 
> do you have any remaining issues to resolve with this set?

What about the review comment about devfreq?

> This is useful not only for OMAP4 and AM3517/3505, but also will probably 
> be useful for the C6x chips that Mark Salter is working on.

It's still in my "to-review" queue, that I'm slowly making my way
through.  So it's not lost, but I would like to get the devfreq
interface question cleared up first.

thanks,

greg k-h
