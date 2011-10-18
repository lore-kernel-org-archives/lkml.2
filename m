Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab1JRN3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:29:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:58464 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab1JRN3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:29:36 -0400
Date: Tue, 18 Oct 2011 15:29:29 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep pointer
 to resource so it can be freed
In-Reply-To: <20111018132603.GC18713@sirena.org.uk>
Message-ID: <Pine.LNX.4.64.1110181527430.17200@ask.diku.dk>
References: <1318909555-12933-1-git-send-email-julia@diku.dk>
 <65EE16ACC360FA4D99C96DC085B3F7722AB64D@039-SN1MPN1-003.039d.mgd.msft.net>
 <Pine.LNX.4.64.1110181517320.17200@ask.diku.dk> <20111018132603.GC18713@sirena.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Mark Brown wrote:

> On Tue, Oct 18, 2011 at 03:18:01PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Add a new variable for storing resources accessed subsequent to the one
> > accessed using request_mem_region, so the one accessed using
> > request_mem_region can be released if needed.
> 
> The same issue applies to all the patches in the series, adding a number
> onto the end of the variable name to make the new one isn't ideal.

I put iores and dmares for the mxs code.  I will look and see if the same 
naming strategy can be used for the other two patches.

julia
