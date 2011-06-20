Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1FTIwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:52:41 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:51084 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1FTIwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:52:40 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 2/2] Add watchdog driver for Intel TunnelCreek
Date: Mon, 20 Jun 2011 10:51:48 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
References: <1308222350-21634-1-git-send-email-alexander.stein@systec-electronic.com> <1308222350-21634-2-git-send-email-alexander.stein@systec-electronic.com> <36169.1308344475@turing-police.cc.vt.edu>
In-Reply-To: <36169.1308344475@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201051.49055.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 June 2011 23:01:15 Valdis.Kletnieks@vt.edu wrote:
> On Thu, 16 Jun 2011 13:05:50 +0200, Alexander Stein said:
> > +config INTEL_TUNNELCREEK_WATCHDOG
> > +	tristate "Intel TunnelCreek watchdog"
> > +	depends on WATCHDOG && PCI && X86
> > +	select MFD_CORE
> > +	select LPC_SCH
> > +	---help---
> > +	  Hardware driver for the watchdog timer built into the Intel
> > +	  Tunnel Creek processor.
> 
> Please add part names here so we don't have to guess/remember what the
> now-retired code name for a processor was.  Just because the guy who wrote
> the driver knows what the development name was doesn't mean that the poor
> guy saying 'make oldconfig' knows whether this is a driver he cares about.
> 
> http://www.engadget.com/2010/09/15/intel-retires-tunnel-creek-codename-debu
> ts-e600-series-atom-sys/

Thanks for the hint.
Would you also recommend to rename the driver module name? Currently it is 
intel_tunnelcreek_watchdog, so it may be called intel_e6xx_watchdog.

Regards,
Alexander
