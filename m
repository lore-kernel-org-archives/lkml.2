Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2AZLYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:24:23 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:30010 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab2AZLYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:24:21 -0500
X-IronPort-AV: E=Sophos;i="4.71,573,1320620400"; 
   d="scan'208";a="141519108"
Date: Thu, 26 Jan 2012 12:24:21 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
In-Reply-To: <20120126105331.GA8041@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.02.1201261221420.1851@localhost6.localdomain6>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien> <20120126105331.GA8041@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jan 2012, Mark Brown wrote:

> On Tue, Jan 24, 2012 at 09:45:26PM +0100, Julia Lawall wrote:
>
>> The various devm_ functions allocate memory that is released when a driver
>> detaches.  This patch uses these functions for data that is allocated in
>> the probe function of a platform device and is only freed in the remove
>> function.
>
> This is a really nice cleanup - I tried to apply it but unfortunately it
> needs a rebase due to the change to use clk_prepare()/clk_unprepare()
> which went in recently.  Could you rebase against current -next please?

Could you tell me in more detail what the problem is?  I pulled linux-next 
and regenerated the patch, but got exactly the same thing as before.  I do 
see some calls to clk_prepare_enable in the code.

thanks,
julia
