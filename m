Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1LTBi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:38:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37162 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464Ab1LTBiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:38:23 -0500
Date: Tue, 20 Dec 2011 01:38:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Message-ID: <20111220013819.GV2860@opensource.wolfsonmicro.com>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EE7A31E.7080301@gmail.com>
 <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
 <20111214120240.GC25088@sirena.org.uk>
 <E30C4693-0D31-4A9A-9E9D-0FC03C5F6B8A@boeing.com>
 <20111217092044.GC2833@opensource.wolfsonmicro.com>
 <D482A908-020C-43E0-ADFC-33AE213D7257@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D482A908-020C-43E0-ADFC-33AE213D7257@boeing.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 10:56:41AM -0600, Moffett, Kyle D wrote:

> I still don't understand how the regulator API is supposed to help in my
> particular case (whole-system poweroff).

Well, it depends what you need to do.  In the ST-Ericsson case what they
needed to do was collapse the core supplies for the CPU.  But previously
you were talking about power domains, not whole system poweroff.
Usually a power domain is a subset of the full system power.
