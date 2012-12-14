Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab2LNSof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:44:35 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:58904 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab2LNSoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:44:34 -0500
Date: Fri, 14 Dec 2012 18:44:31 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>, Roger Quadros <rogerq@ti.com>,
        Benoit Cousson <b-cousson@ti.com>
cc: balbi@ti.com, sameo@linux.intel.com, keshava_mgowda@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Mike Turquette <mturquette@gmail.com>
Subject: Re: [PATCH v4 16/23] ARM: OMAP2+: clock data: Merge utmi_px_gfclk
 into usb_host_hs_utmi_px_clk
In-Reply-To: <20121214182855.GB4989@atomide.com>
Message-ID: <alpine.DEB.2.00.1212141838130.5915@utopia.booyaka.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com> <1355134833-5199-17-git-send-email-rogerq@ti.com> <20121214182855.GB4989@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-1894758297-1355510671=:5915"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-1894758297-1355510671=:5915
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi

On Fri, 14 Dec 2012, Tony Lindgren wrote:

> Paul, what about this patch? Looks like you've acked the other clock=20
> patches in this series but not this one?

I commented on it briefly here:

https://patchwork.kernel.org/patch/1838111/

Maybe Beno=EEt could comment here, but it looks to me (based on a=20
superficial look at the hardware clock tree data) that these clock nodes=20
should exist.  In an ideal world, we'd be able to get back to the=20
autogeneration of this clock data.

Roger, is it a requirement for the driver to remove these clock nodes, or=
=20
is it possible to stick with the existing nodes?


- Paul
--843723315-1894758297-1355510671=:5915--
