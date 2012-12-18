Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2LRAuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:50:18 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:56365 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LRAuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:50:16 -0500
Message-ID: <50CFBDC4.8040109@gmail.com>
Date: Tue, 18 Dec 2012 01:50:12 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: Dove: add Cubox sdhci card detect gpio
References: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com> <1355790269-10596-3-git-send-email-sebastian.hesselbarth@gmail.com> <20121218003810.GP21694@titan.lakedaemon.net>
In-Reply-To: <20121218003810.GP21694@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 01:38 AM, Jason Cooper wrote:
 > On Tue, Dec 18, 2012 at 01:24:29AM +0100, Sebastian Hesselbarth wrote:
 >> Card detect for sdhci on Cubox is connected to the wrong pin
 >> (sdio1_cd instead of sdio0_cd). With support for cd-gpios and
 >> pinctrl add the corresponding properties to DT for Cubox.
 >>
 >> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
 >> ...
 >> +&sdio0 {
 >> +	status = "okay";
 >> +	/* sdio0 card detect is connected to wrong pin on CuBox */
 >> +	cd-gpios =<&gpio0 12 1>;
 >
 > this looks like a fix that should be merged into v3.8, I'll cue it up
 > for v3.8-rc2.

Jason,

it is more a feature than a fix, as gpio-cd support for sdhci-dove
moved in lately. You want me to split this patch from the other two
(that I'll reorder as requested)?

Sebastian
