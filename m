Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049Ab2EXSIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:08:23 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:59074 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964792Ab2EXSIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:08:21 -0400
Message-ID: <4FBE7915.2000704@xenotime.net>
Date: Thu, 24 May 2012 11:08:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: linux-next: Tree for May 24 (hwmon/sch56xx)
References: <20120524164915.fc6b1d90b75c50baab856280@canb.auug.org.au>
In-Reply-To: <20120524164915.fc6b1d90b75c50baab856280@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/12 23:49, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120523:




when CONFIG_WATCHDOG is not enabled:

drivers/built-in.o: In function `sch56xx_watchdog_register':
(.text+0x50711c): undefined reference to `watchdog_register_device'
drivers/built-in.o: In function `sch56xx_watchdog_unregister':
(.text+0x507171): undefined reference to `watchdog_unregister_device'

or when SCH56XX_COMMON=m:

ERROR: "watchdog_unregister_device" [drivers/hwmon/sch56xx-common.ko] undefined!
ERROR: "watchdog_register_device" [drivers/hwmon/sch56xx-common.ko] undefined!


-- 
~Randy
