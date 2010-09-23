Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0IWLcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:32:11 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:40608 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab0IWLcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:32:09 -0400
Message-ID: <4C9B3A3A.8040908@stericsson.com>
Date: Thu, 23 Sep 2010 13:30:02 +0200
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        l-o <linux-omap@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        linux-doc <linux-doc@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v3] power: introduce library for device-specific OPPs
References: <[PATCH] opp: introduce library for device-specific OPPs> <1285192054-454-1-git-send-email-nm@ti.com>
In-Reply-To: <1285192054-454-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon wrote:

> To implement an OPP, some sort of power management support is necessary
> hence this library depends on CONFIG_PM.

Suits my needs, so FWIW
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
