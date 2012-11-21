Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2KUEJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:09:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37129 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2KUEJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:09:27 -0500
Date: Wed, 21 Nov 2012 04:09:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: s3c2410: Get the i2c bus number from alias id
Message-ID: <20121121040913.GA13280@sirena.org.uk>
References: <1353450428-2615-1-git-send-email-dianders@chromium.org>
 <1353450428-2615-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353450428-2615-2-git-send-email-dianders@chromium.org>
X-Cookie: You will be surrounded by luxury.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:27:04PM -0800, Doug Anderson wrote:
> From: Padmavathi Venna <padma.v@samsung.com>
> 
> Get the i2c bus number that the device is connected to using the alias
> id.  This makes debugging / grokking of kernel messages much easier.

This doesn't look like a s3c2410 specific change - it's a generic device
tree issue.  This suggests that it sohuld be implemented in the
framework so that all I2C controllers with DT can use it.
