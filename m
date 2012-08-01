Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2HAT4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:56:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34589 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2HAT4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:56:22 -0400
Date: Wed, 1 Aug 2012 14:56:16 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Andreas Heider <andreas@meetr.de>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: [PATCH] apple-gmux: Restore switch registers on suspend/resume
Message-ID: <20120801195616.GF22963@thinkpad-t410>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andreas Heider <andreas@meetr.de>,
	Arun Raghavan <arun.raghavan@collabora.co.uk>,
	linux-kernel@vger.kernel.org, airlied@redhat.com
References: <4FFCC7FB.1090609@meetr.de>
 <1343522547.2488.12.camel@shinybook.infradead.org>
 <1343524730.1962.5.camel@shinybook.infradead.org>
 <20120729193953.GA25132@srcf.ucam.org>
 <1343595171.2511.1.camel@shinybook.infradead.org>
 <20120729205859.GA25819@srcf.ucam.org>
 <20120731151856.GA19979@thinkpad-t410>
 <1343835344.26866.150.camel@shinybook.infradead.org>
 <20120801155914.GB22963@thinkpad-t410>
 <1343850238.26866.171.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343850238.26866.171.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:43:58PM +0100, David Woodhouse wrote:
> On Wed, 2012-08-01 at 10:59 -0500, Seth Forshee wrote:
> > since there still doesn't seem to be any way
> > to get the vbios for the Intel graphics.
> 
> Hm, wait. With Matthew's patches to get the Radeon BIOS from EFI, there
> *is* also a ROM image for the Intel device. Have we tried that?

You get a ROM image? Because I'm still not getting one, and the opregion
VBT is invalid as well. I wonder if it's a difference in the machines or
in how you're booting it.

I've got the EFI stub enabled in my build, and I'm booting the kernel
directly from refit (no bootloader). I'm not doing any gmux writes to
switch to the IGPU when I boot. Are you doing something different?

