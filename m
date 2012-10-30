Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2J3Hjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:39:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58360 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2J3Hjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:39:35 -0400
Message-ID: <508F842D.8000407@ti.com>
Date: Tue, 30 Oct 2012 08:39:25 +0100
From: =?UTF-8?B?UMOpdGVyIFVqZmFsdXNp?= <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121022 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] CLK: clk-twl6040: Initial clock driver for OMAP4+ McPDM
 fclk clock
References: <1347633027-20731-1-git-send-email-peter.ujfalusi@ti.com> <20121029173008.18780.35000@nucleus>
In-Reply-To: <20121029173008.18780.35000@nucleus>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 10/29/2012 06:30 PM, Mike Turquette wrote:
> Peter,
> 
> The patch looks good to me.  To be clear, you wan this to go through
> clk-next or the mfd tree for avoiding conflicts?

clk-next is the best place for it I think. The MFD part to register the device
can still wait till we have ccf support on OMAP4.

Thank you,
Péter
