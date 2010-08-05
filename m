Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab0HEOI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:08:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36863 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231Ab0HEOIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:08:25 -0400
Date: Thu, 5 Aug 2010 16:08:13 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org,
        "Samuel R. C. Vale" <srcvale@holoscopio.com>,
        Andrew Victor <linux@maxim.org.za>
Subject: [PATCH 00/19] More section fixes [Was: Re: [PATCH 01/11] ARM:
	cam60: move cam60_spi_devices to .init.data]
Message-ID: <20100805140813.GA13859@pengutronix.de>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I updated the series and added a few more fixes.  The usb-fixes were
already sent to linux-usb ML, the others are new.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
