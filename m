Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab1AELS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:18:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52434 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1AELS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:18:56 -0500
Date: Wed, 5 Jan 2011 11:18:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@suse.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 0/2] Annotate gpio-configuration with __must_check
Message-ID: <20110105111853.GA10317@sirena.org.uk>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de> <20110104202718.GA31444@suse.de> <20110104212916.GA14436@pengutronix.de> <20110104213414.GA6774@suse.de> <20110104230508.GA18363@pengutronix.de> <20110104234440.GC30328@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104234440.GC30328@suse.de>
X-Cookie: APL hackers do it in the quad.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 03:44:40PM -0800, Greg KH wrote:

> But no, a WARN() might not be that nice as it usually is never seen by
> embedded developers...

They're probably about as relaible as build warning; spewing over the
serial console is pretty visible if yu're using one.
