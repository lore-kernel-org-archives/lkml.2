Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2ADELP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 23:11:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34421 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab2ADELM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 23:11:12 -0500
Date: Wed, 4 Jan 2012 08:11:03 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, pali.rohar@gmail.com, prakity@mavell.com,
        broonie@opensource.wolfsonmicro.com, lars@metafoo.de,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] power: introduce Charger-Manager
Message-ID: <20120104041103.GA12650@oksana.dev.rtsoft.ru>
References: <1324979269-2453-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1324979269-2453-1-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 06:47:47PM +0900, Donggeun Kim wrote:
> Charger Manager provides in-kernel battery charger management that
> requires temperature monitoring during both normal and suspend-to-RAM states
> and where each battery may have multiple chargers attached and the userland
> wants to look at the aggregated information of the multiple chargers.
> 
> Charger Manager is a platform_driver with power-supply-class entries.
> An instance of Charger Manager (a platform-device created with
> Charger-Manager) represents a battery with chargers. If there are multiple
> batteries with their own chargers acting independently in a system,
> the system may need multiple instances of Charger Manager.
> Multiple chargers (e.g., USB, wireless, and solar panels) may be included
> as pairs of a regulator and a power-supply-class
> per charger.
> 
> Charger Manager glues multiple charger-related frameworks (regulators of
> chargers, power-supply-class from chargers and fuel-gauge, RTC,
> suspend-again, ...) together to provide aggregated information and
> transparent battery monitoring to userspace.
> 
> For the discussions about the need for in-suspend monitoring, please
> refer to the discussions of suspend-again in PM:
> v1 https://lists.linux-foundation.org/pipermail/linux-pm/2011-April/031052.html
> v2 https://lists.linux-foundation.org/pipermail/linux-pm/2011-April/031111.html
> v3 https://lists.linux-foundation.org/pipermail/linux-pm/2011-May/031267.html
> v4 https://lists.linux-foundation.org/pipermail/linux-pm/2011-May/031357.html
> v5 (last, applied) https://lists.linux-foundation.org/pipermail/linux-pm/2011-June/031561.html
> 
> To see the usage example, please refer to:
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/charger-manager
> In this git branch, a test code for Exynos4-NURI is shown.
> 
> This patch set supports initial Charger Manager driver.

Merged, thanks! I'm pretty excited, we have a full fledged charger
manager, yay! :-)

Please send all further improvements against these patches, or (better)
against battery-2.6.git tree: http://git.infradead.org/battery-2.6.git

Much thanks for your hard work! Also million thanks to reviewers!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
