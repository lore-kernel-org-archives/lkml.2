Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1FXMmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:42:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57938 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1FXMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:42:04 -0400
Date: Fri, 24 Jun 2011 13:41:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wu DaoGuang <wdgvip@gmail.com>
Cc: ben-linux@fluff.org, kgene.kim@samsung.com, dmitry.torokhov@gmail.com,
        wdgvip@gamil.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] INPUT:Add ABS_PRESSURE input event support for
	touchscreen driver
Message-ID: <20110624124154.GC19804@sirena.org.uk>
References: <1308881738-6392-1-git-send-email-wdgvip@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308881738-6392-1-git-send-email-wdgvip@gmail.com>
X-Cookie: Will it improve my CASH FLOW?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 10:15:38AM +0800, Wu DaoGuang wrote:
> The touchscreen driver s3c2410_ts.c doesn't work well when using
> the tslib, an abstraction layer for touchscreen panel events.
> Tslib needs ABS_X ABS_Y and ABS_PRESSURE events to report, but only
> the former two the driver can provide.

It seems much more sane to fix this in tslib, the kernel is not actually
reporting pressure meaningfully here and there's already BTN_TOUCH to
report if the pen is down.
