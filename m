Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3ACO2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:28:44 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:38656 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3ACO2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:28:42 -0500
X-Greylist: delayed 89178 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2013 09:28:42 EST
MIME-Version: 1.0
In-Reply-To: <20130103111450.GC14714@gmail.com>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
	<1355937587-31730-4-git-send-email-lee.jones@linaro.org>
	<CACRpkda79O_b3Z8g7Sy7vMtW9neZU4x-Z=iEQgjqu4X5tFKyhw@mail.gmail.com>
	<20121220192441.GC14363@n2100.arm.linux.org.uk>
	<20121220203514.GN2691@gmail.com>
	<20121220205113.GD14363@n2100.arm.linux.org.uk>
	<20121221091306.GO2691@gmail.com>
	<20121221092421.GG14363@n2100.arm.linux.org.uk>
	<20121221114105.GP2691@gmail.com>
	<20130103111450.GC14714@gmail.com>
Date: Thu, 3 Jan 2013 15:28:42 +0100
Message-ID: <CACRpkda-4C+ezaZFSkxsNbmHnBN8RCoCeGePaOF-DzV0XnkzQw@mail.gmail.com>
Subject: Re: [PATCH 4/4 v3] net/smsc911x: Provide common clock functionality
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Robert Marklund <robert.marklund@stericsson.com>,
        linus.walleij@stericsson.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 12:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Some platforms provide clocks which require enabling before the
> SMSC911x chip will power on. This patch uses the new common clk
> framework to do just that. If no clock is provided, it will just
> be ignored and the driver will continue to assume that no clock
> is required for the chip to run successfully.
>
> Cc: Steve Glendinning <steve.glendinning@shawell.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks all right to me now:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
