Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1JRN0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:26:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53580 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab1JRN0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:26:09 -0400
Date: Tue, 18 Oct 2011 14:26:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep
 pointer to resource so it can be freed
Message-ID: <20111018132603.GC18713@sirena.org.uk>
References: <1318909555-12933-1-git-send-email-julia@diku.dk>
 <65EE16ACC360FA4D99C96DC085B3F7722AB64D@039-SN1MPN1-003.039d.mgd.msft.net>
 <Pine.LNX.4.64.1110181517320.17200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110181517320.17200@ask.diku.dk>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 03:18:01PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Add a new variable for storing resources accessed subsequent to the one
> accessed using request_mem_region, so the one accessed using
> request_mem_region can be released if needed.

The same issue applies to all the patches in the series, adding a number
onto the end of the variable name to make the new one isn't ideal.
