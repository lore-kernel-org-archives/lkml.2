Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1JROKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:10:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56150 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1JROKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:10:39 -0400
Date: Tue, 18 Oct 2011 16:10:32 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep pointer to resource
 so it can be freed
In-Reply-To: <Pine.LNX.4.64.1110181517320.17200@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1110181610050.17200@ask.diku.dk>
References: <1318909555-12933-1-git-send-email-julia@diku.dk>
 <65EE16ACC360FA4D99C96DC085B3F7722AB64D@039-SN1MPN1-003.039d.mgd.msft.net>
 <Pine.LNX.4.64.1110181517320.17200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, I have now sent another single patch that does the same for all 
5 files.

julia
