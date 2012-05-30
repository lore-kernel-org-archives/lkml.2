Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2E3So2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:44:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab2E3SoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:44:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [RFC PATCH 0/5] omap: add ocp2scp as a misc driver
Date: Wed, 30 May 2012 18:43:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
In-Reply-To: <1338375394-16268-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205301843.51568.arnd@arndb.de>
X-Provags-ID: V02:K0:YeK3hbW4M7uxH+0T7Sv58BOwivIUOoYs88rsBngW5YG
 MFj9gKY2sKo2+DVg4XabwOo+TO1coWvpF1qku3l/ThZlyiAUDl
 v1yIxOh8H6zfmUujN4ofRFhykYsbatGeJw6y3EQcPvJkc9fJKq
 +bqCCYpkLsN/mRDyix8loDWpD/UqPDmvBDpyf7ffAUckZeksB0
 ZAvcS8rdHa2m9KzqOlFCIQ/BFLxa6vTYcZdWHatW+hZ/NgikFb
 EBE54znXNNKYx4bEJox2FYajUKm6fYLIZFBvF1WTxynSKjkXhd
 Qma7xjXgnhRjJJjp1uncleyHIzVJo46A9MxNRmyE8gWxdQ1qXh
 D3lnRzMLSYo3Ulda6AqE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2012, Kishon Vijay Abraham I wrote:
> 
> This patch series is done as a preparatory step for adding phy drivers
> for dwc3 and musb.
> 
> This series adds a new driver for ocp2scp to which phy drivers are connected.
> 
> I'm planning to send phy drivers asap. Meanwhile I'd like to get some
> review comments for this series. I have also plans to send device tree
> adaptation of the ocp2scp driver.
> 
> Developed on
> http://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-next
> 
> If it has to be based on some other tree, please let me know.

This must be the most pointless driver I've seen in a long time. It doesn't
actually do anything at all, it just creates child devices from a static
lookup table.

Just put the devices you actually want into the device tree instead and
have them automatically created.

	Arnd
