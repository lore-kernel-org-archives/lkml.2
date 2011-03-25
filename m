Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab1CYAM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 20:12:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55180 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1CYAMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 20:12:21 -0400
Date: Fri, 25 Mar 2011 00:12:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv2 0/4] Support for OTP memory
Message-ID: <20110325001216.GA26856@sirena.org.uk>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <AANLkTim3kMCE=LhCRcUDif8ENSA-E-_Xga5cDSYs0x25@mail.gmail.com> <20110324174722.GH3130@pulham.picochip.com> <AANLkTinDWA1xU1G0kBk8XPr_ZaRgHtBQP60DX6-x3tsn@mail.gmail.com> <20110324183205.GI3130@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324183205.GI3130@pulham.picochip.com>
X-Cookie: Live free or die.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 06:32:05PM +0000, Jamie Iles wrote:

> Yes, we have a similar thing here - a block of OTP from an IP vendor and 
> a wrapper to provide an AXI interface.  As far as I know there are only 
> a few OTP vendors so there may well be plenty of common code in 
> different OTP implementations.

Seems possible, though I'm not sure how much of the register interface
the OTP vendors provide so how much low level compatibility there might
be.
