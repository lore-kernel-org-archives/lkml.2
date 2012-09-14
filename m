Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab2INQlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:41:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46111 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab2INQlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:41:50 -0400
Message-ID: <50535E49.5060903@wwwdotorg.org>
Date: Fri, 14 Sep 2012 10:41:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/10] pinctrl: mvebu: pinctrl driver
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 09:41 AM, Sebastian Hesselbarth wrote:
> This patch set adds a core pinctrl driver for Marvell MVEBU SoCs and
> SoC specific stubs for Armada 370, Armada XP, Dove, and Kirkwood.
> The SoC specific stubs use the pinctrl-mvebu core driver that handles
> pinctrl API and register accesses for common pinctrl registers.
> 
> As especially Dove has some pinctrl registers that do not match the
> common pinctrl register layout the core driver has been extended by
> some callbacks to allow uncommon Dove pinctrl registers.
> 
> DT binding documentation is added for all supported SoCs but as
> Dove and Kirkwood are not yet ready for full DT support, the pinctrl
> driver is only activated for Armada 370 and XP.
> 
> The driver of latest patch v4 has been tested on Dove, Armada 370, 
> Armada XP, and 88f6281 variant of Kirkwood.

The series,
Reviewed-by: Stephen Warren <swarren@wwwdotorg.org>

(Mainly the DT bindings and .dts file edits)

In past versions of this series, we were had discussions about the best
way to represent the data tables in the SoC-specific pinctrl drivers. I
haven't actually looked at the current state in this patchset, but since
this is an internal implementation detail and doesn't affect the DT
bindings at all, I figure it's not a big deal right now; if it is ever a
problem, it can be fixed without affecting anything outside the driver,
so I won't worry about it:-)
