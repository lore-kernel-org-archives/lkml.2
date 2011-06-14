Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1FNNyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:54:15 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:53728 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1FNNyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:54:13 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 09:54:13 EDT
Date: Tue, 14 Jun 2011 15:48:59 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Walter Goossens <waltergoossens@home.nl>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: [PATCH v3 RESEND] watchdog: Add driver for Altera Watchdog
	Timer
Message-ID: <20110614134859.GP20966@distanz.ch>
References: <1300461573-12268-1-git-send-email-tklauser@distanz.ch> <20110527082309.GB16394@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527082309.GB16394@infomag.iguana.be>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim

On 2011-05-27 at 10:23:09 +0200, Wim Van Sebroeck <wim@iguana.be> wrote:
> > This driver adds support for the Altera Timer in the Watchdog Timer
> > configuration. This component is usually found on SOPC (System on
> > Programmable Chip) for Altera FPGAs.
> > 
> > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > Reviewed-by: Jamie Iles <jamie@jamieiles.com>
> > Acked-by: Grant Likely <grant.likely@secretlab.ca> (for the devicetree binding)
> 
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> I presume this will go in together with the other nios2 architecture patches?

It will probably take some time until we get to the point where we're
ready to submit nios2 arch patches. We started out with individual
drivers to get used to the submission and review process. Most of them
got taken by the respective subsystem maintainers.

So if you want to take the driver through your tree, please go ahead.
Otherwise I will resubmit it once we're ready to submit the nios2 arch.

Cheers
Tobias
