Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1JJX0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 19:26:50 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:40529 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1JJX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 19:26:49 -0400
Date: Mon, 10 Oct 2011 17:26:48 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
In-Reply-To: <4E936F0E.9050203@ti.com>
Message-ID: <alpine.DEB.2.00.1110101725140.5205@utopia.booyaka.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com> <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com>
 <4E936F0E.9050203@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Cousson, Benoit wrote:

> In fact the device name does not have to match the hwmod name. So we can just
> create an "omap2_prm" omap_device for OMAP2, "omap3_prm" omap_device for
> OMAP3...
> That will allow the relevant PRM  driver to be bound to the proper device.

Incidentally, given that we would be using the hwmod name and the version 
number to determine the appropriate omap_device name, what IP version 
numbers should we assign to these PRM IP blocks for different SoCs?


- Paul
