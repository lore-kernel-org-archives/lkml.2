Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab0I1EME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 00:12:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37770 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750725Ab0I1EMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 00:12:02 -0400
Date: Mon, 27 Sep 2010 21:12:18 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Alek Du <alek.du@intel.com>,
        Richard =?utf-8?B?UhskQotLGyhCZm9ycw==?= 
	<richard.rojfors@mocean-labs.com>,
        Mike Frysinger <vapier@gentoo.org>, meego-dev@meego.com,
        ML linux-kernel <linux-kernel@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, andrew.chih.howe.khor@intel.com,
        gregkh@suse.de, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Message-ID: <20100928041217.GA8882@opensource.wolfsonmicro.com>
References: <4C80D3C8.9020204@dsn.okisemi.com>
 <20100903134827.GA7614@rakim.wolfsonmicro.main>
 <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 12:21:10PM +0900, Masayuki Ohtake wrote:

> > You should be implementing support for the device using the
> > standard interfaces used by the other GPIO drivers in kernel.

> I don't understand how userspace accesses to the driver.
> Let me know how to ? sysfs only ?

sysfs, though at least as often another driver in the kernel will
interact with the GPIOs.  Search the kernel for users of the gpiolib
APIs.
