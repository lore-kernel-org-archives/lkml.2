Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab2LUJZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:25:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35357 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2LUJZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:25:41 -0500
Date: Fri, 21 Dec 2012 09:24:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Robert Marklund <robert.marklund@stericsson.com>,
        linus.walleij@stericsson.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] net/smsc911x: Provide common clock functionality
Message-ID: <20121221092421.GG14363@n2100.arm.linux.org.uk>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org> <1355937587-31730-4-git-send-email-lee.jones@linaro.org> <CACRpkda79O_b3Z8g7Sy7vMtW9neZU4x-Z=iEQgjqu4X5tFKyhw@mail.gmail.com> <20121220192441.GC14363@n2100.arm.linux.org.uk> <20121220203514.GN2691@gmail.com> <20121220205113.GD14363@n2100.arm.linux.org.uk> <20121221091306.GO2691@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221091306.GO2691@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 09:13:06AM +0000, Lee Jones wrote:
> Are you saying remove "pdata->clk = NULL;" and test for IS_ERR
> every time?

Exactly.
