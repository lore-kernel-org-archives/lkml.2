Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2DQPCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:02:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37274 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab2DQPCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:02:35 -0400
Date: Tue, 17 Apr 2012 16:02:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Add Wolfson Microelectronics WM8776 codec ALSA
 driver
Message-ID: <20120417150234.GB22575@sirena.org.uk>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
 <1334611118-10301-4-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334611118-10301-4-git-send-email-linux@rainbow-software.org>
X-Cookie: The savior becomes the victim.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 11:18:37PM +0200, Ondrej Zary wrote:
> Needed by Philips PSC724 subdriver. The code does not contain any
> card-specific bits so it can be used by any other ALSA driver.

Same comments as the previous patch, this should be using ASoC.  In this
case the device has in fact been supported in mainline since 2.6.32...
