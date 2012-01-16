Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2APQos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:44:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36904 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2APQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:44:42 -0500
Date: Mon, 16 Jan 2012 16:44:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Darren Hart <dvhart@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of
 failing probe
Message-ID: <20120116164424.GA19621@sirena.org.uk>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AF47@saturn3.aculab.com>
 <4F1451BD.9030904@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1451BD.9030904@linux.intel.com>
X-Cookie: Swap read error.  You lose your mind.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 08:35:09AM -0800, Arjan van de Ven wrote:
> On 1/16/2012 8:20 AM, David Laight wrote:

> > Since multiple interfaces on a single system are unlikely
> > to be connected to the same LAN segment, it doesn't really
> > matter if they use same MAC address.

> I think you missed the point. All embedded devices have the same fs, so
> if you have 2 boxes of the same model/brand on the same network, they'd
> have the same MAC. That's generally frowned upon by network
> administrators ;-)

This is generally handled by putting the MAC into a board-specific bit
of flash that isn't part the main firmware (for example, the bootloader
configuration) - for a lot of applications random generation doesn't
help that much as entropy is hard to come by.
