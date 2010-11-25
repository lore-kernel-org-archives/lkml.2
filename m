Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0KYO2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:28:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35519 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0KYO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:28:06 -0500
Date: Thu, 25 Nov 2010 14:28:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        sakari.ailus@maxwell.research.nokia.com, lennart@poettering.net
Subject: Re: [RFC/PATCH v6 00/12] Media controller (core and V4L2)
Message-ID: <20101125142803.GA15099@sirena.org.uk>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:28:07AM +0100, Laurent Pinchart wrote:

> I want to emphasize that the media controller API does *not* replace the V4L,
> DVB or ALSA APIs. It complements them.

Overall this looks relatively good and should be mappable onto the
embedded audio stack.  I'd need to sit down and actually do that to
go into too much specific detail but the only real issue I see is
working out how the control aspects of this interact with the control in
ALSA.  The simplest thing would be to have the userspace API be read
only for ALSA devices, I guess.

One potential issue 
