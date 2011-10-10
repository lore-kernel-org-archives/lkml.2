Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1JJWfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:35:18 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37074 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1JJWfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:35:15 -0400
Date: Mon, 10 Oct 2011 16:35:14 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
In-Reply-To: <4E936F0E.9050203@ti.com>
Message-ID: <alpine.DEB.2.00.1110101631450.5205@utopia.booyaka.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com> <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com>
 <4E936F0E.9050203@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Cousson, Benoit wrote:

> On 10/10/2011 10:42 PM, Paul Walmsley wrote:
>
> > If it's the "3xxx" that you're objecting to in the name, we could call it
> > "prm2" or "prmxyz" - the '3xxx' just seemed like the most logical
> > approach.  The name of the hwmod class in the patch is still "prm", of
> > course.
> 
> Yes, but that's different, the number is supposed to represent the instance
> number in the IP naming convention. So prm2 != prmv2.

Heh, that works as long as there's no "prmv" IP block ;-)

> > Thoughts?
> 
> In fact the device name does not have to match the hwmod name. So we can just
> create an "omap2_prm" omap_device for OMAP2, "omap3_prm" omap_device for
> OMAP3...
> That will allow the relevant PRM  driver to be bound to the proper device.

We can, we'd just need to add this extra mapping layer, so it doesn't 
become a nasty special-case hack for each IP block that this applies to.

Sounds like something for 3.3 (if ever...)


- Paul
