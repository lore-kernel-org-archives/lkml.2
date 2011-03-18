Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1CRSZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:25:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47297 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753937Ab1CRSZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:25:20 -0400
Date: Fri, 18 Mar 2011 18:25:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Anders <x0132446@ti.com>
Cc: "andy.green@linaro.org" <andy.green@linaro.org>,
        Andy Green <andy@warmcat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110318182518.GA2271@opensource.wolfsonmicro.com>
References: <4D83A25C.804@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D83A25C.804@ti.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 01:20:12PM -0500, David Anders wrote:

> if you grep in drivers/net you will find a wide range of network
> devices that use the random_ether_addr() function:

This is a slightly different case to the one where device tree is most
useful which is the case where there is a MAC assigned to the system but
it's been stored in an alternative location and needs to be programmed
into the NIC by software.
