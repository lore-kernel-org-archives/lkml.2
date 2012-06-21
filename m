Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab2FUIJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:09:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40360 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab2FUIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:09:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120619135600.GX12766@atomide.com>
References: <20120611135826.GB12766@atomide.com>
	<4FDA6FCD.1020605@wwwdotorg.org>
	<20120615094938.GQ12766@atomide.com>
	<4FDB6000.5080703@wwwdotorg.org>
	<20120618055036.GU12766@atomide.com>
	<20120619135600.GX12766@atomide.com>
Date: Thu, 21 Jun 2012 10:09:03 +0200
Message-ID: <CACRpkdbi1V+Y6cMSNX_Rk_ccjk35eB6c_EJbNY620QFS8F_KRQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Add one-register-per-pin type device tree based
 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 3:56 PM, Tony Lindgren <tony@atomide.com> wrote:

> Below is the pinctrl-single patch updated with hopefully all the Stephen's
> comments addressed. The binding still needs to be looked at, see relevant
> parts of the discussion below.

I am happy with the code and the way it interacts with the pinctrl subsystem!

Now all I need to merge this is a few ACKs from select people, and
since this has a deep impact on the way device tree is used I would
*really* like for Grant or Rob to ACK it.

Yours,
Linus Walleij
