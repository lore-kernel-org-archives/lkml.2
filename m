Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab1LNMCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 07:02:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59737 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1LNMCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 07:02:42 -0500
Date: Wed, 14 Dec 2011 12:02:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Message-ID: <20111214120240.GC25088@sirena.org.uk>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EE7A31E.7080301@gmail.com>
 <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
X-Cookie: Inside, I'm already SOBBING!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 02:44:48PM -0600, Moffett, Kyle D wrote:

> I looked at it a bit when I was generalizing my code, but it seemed
> dramatically more complicated than I needed, and I couldn't see any
> reasonable way to hook it from the machine_poweroff() code.

Some ST platform had to do odd stuff with regulators to power off, it
made a platform device representing the odd poweroff code.

> There's also the fact that I was looking for a pure-device-tree type
> of driver and the regulator framework does not seem to support the
> standard OF-platform probe system.

The regulator API in -next has DT bindings.
