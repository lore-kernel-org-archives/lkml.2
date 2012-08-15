Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2HOTXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:23:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50148 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab2HOTXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:23:38 -0400
Message-ID: <502BF734.9000608@wwwdotorg.org>
Date: Wed, 15 Aug 2012 13:23:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: vt8500-wm8505-linux-kernel@googlegroups.com, linux-fbdev@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Andersson <eric.andersson@unixphere.com>,
        linux-serial@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hauke Mehrtens <hauke@hauke-m.de>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>, Neil Zhang <zhangwm@marvell.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCHv2 0/8] *** ARM: Update arch-vt8500 to Devicetree ***
References: <1344477300-25251-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1344477300-25251-1-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 07:54 PM, Tony Prisk wrote:
> This patchset updates arch-vt8500 to devicetree and removes all the old-style
> code. Support for WM8650 has also been added.

Sorry for taking such a long time to re-review this.

I scanned the series looking for just the changes to the issues I raised
on v1, and I do see almost everything has been fixed up OK, except for
the one issue I just commented on. So, aside from that, this series is
fine by me. I'll defer to others about whether it's necessary to fix the
display node-name-vs.-phandle issue I pointed out, or defer that until
later.
