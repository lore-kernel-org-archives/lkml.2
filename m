Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946282Ab2EKWXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:23:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab2EKWXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:23:52 -0400
Date: Fri, 11 May 2012 15:23:48 -0700
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [ 046/167] [PATCH] spi: Fix device unregistration when
 unregistering the bus master
Message-ID: <20120511222347.GA22143@herton-ThinkPad-T420>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055036.064659639@decadent.org.uk>
 <20120509193335.GD15527@herton-ThinkPad-T420>
 <1336706149.8274.431.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336706149.8274.431.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:15:49AM +0100, Ben Hutchings wrote:
> On Wed, 2012-05-09 at 12:33 -0700, Herton Ronaldo Krzesinski wrote:
> > On Wed, May 09, 2012 at 06:51:15AM +0100, Ben Hutchings wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > > commit 178db7d30f94707efca1a189753c105ef69942ed upstream.
> > 
> > After applying this change, this introduces a bug on spi-fsl-spi.c, we
> > need to apply in addition to this change commit
> > 5039a86973cd35bdb2f64d28ee12f13fe2bb5a4c
> [...]
> 
> OK, I've added that to the queue.  But doesn't fsl_spi_cs_control() also
> need to be changed?

I think so as well, I took a look and if no one beats me to it I'll send
a patch for that with Cc: stable.

> 
> Ben.
> 
> -- 
> Ben Hutchings
> Life is what happens to you while you're busy making other plans.
>                                                                - John Lennon

-- 
[]'s
Herton
