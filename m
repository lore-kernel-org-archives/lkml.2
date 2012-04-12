Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137Ab2DLDMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:12:38 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:45641 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab2DLDMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:12:37 -0400
Date: Wed, 11 Apr 2012 21:12:36 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Aneesh V <aneesh@ti.com>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        mgreer@animalcreek.com, msalter@redhat.com
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
In-Reply-To: <20120412030044.GA26236@kroah.com>
Message-ID: <alpine.DEB.2.00.1204112110160.29473@utopia.booyaka.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com> <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com> <20120412030044.GA26236@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for the response Greg,

Hi Aneesh,

On Wed, 11 Apr 2012, Greg KH wrote:

> On Wed, Apr 11, 2012 at 08:44:39PM -0600, Paul Walmsley wrote:
> > On Sat, 17 Mar 2012, Aneesh V wrote:
> > 
> > > Add a driver for the EMIF SDRAM controller used in TI SoCs
> > > 
> > > EMIF is an SDRAM controller that supports, based on its revision,
> > > one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
> > > for LPDDR2.
> > 
> > Just checking to see what the current state of this series is.  Greg, are 
> > you considering this for merging, or are there remaining issues?  Aneesh, 
> > do you have any remaining issues to resolve with this set?
> 
> What about the review comment about devfreq?
> 
> > This is useful not only for OMAP4 and AM3517/3505, but also will probably 
> > be useful for the C6x chips that Mark Salter is working on.
> 
> It's still in my "to-review" queue, that I'm slowly making my way
> through.  So it's not lost, but I would like to get the devfreq
> interface question cleared up first.

Aneesh, care to address the devfreq comments? 

I haven't looked at the series closely, so unfortunately I'm not presently 
in a position to comment.


- Paul
