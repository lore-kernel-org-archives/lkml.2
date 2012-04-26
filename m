Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab2DZQcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:32:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52901 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab2DZQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:32:54 -0400
Message-ID: <4F9978B1.3050203@wwwdotorg.org>
Date: Thu, 26 Apr 2012 10:32:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, cjb@laptop.org,
        b20223@freescale.com
Subject: Re: [PATCH v3 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl subsystem
References: <1335451227-27709-1-git-send-email-b29396@freescale.com> <1335451227-27709-4-git-send-email-b29396@freescale.com>
In-Reply-To: <1335451227-27709-4-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 08:40 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This driver is shared between many platforms. Currently only imx6q has
> pinctrl support, to avoid breaking other platforms that do not have pinctrl
> support to run this driver, enable pinctrl dummy state for them before
> they also convert to pinctrl subsystem.

The series,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

(My ack isn't meant to override or influence any discussions between
Freescale maintainers re: the binding, but more that the binding seems
to be /a/ reasonable solution, and is specified well enough that I
understand what's going on there)
