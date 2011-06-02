Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1FBF1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:27:14 -0400
Received: from linux-sh.org ([111.68.239.195]:32962 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1FBF1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:27:12 -0400
Date: Thu, 2 Jun 2011 14:24:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        vapier@gentoo.org, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, gxt@mprc.pku.edu.cn, david.woodhouse@intel.com,
        akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de,
        mingo@elte.hu, rientjes@google.com, w.sang@pengutronix.de,
        sam@ravnborg.org, manuel.lauss@googlemail.com, anton@samba.org,
        arnd@arndb.de
Subject: Re: [PATCH] Fix build warning of the defconfigs
Message-ID: <20110602052452.GA6087@linux-sh.org>
References: <1306945763-6583-1-git-send-email-wanlong.gao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306945763-6583-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 12:29:23AM +0800, Wanlong Gao wrote:
> RTC_CLASS is changed to bool.
> So value 'm' is invalid.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>

>  arch/sh/configs/titan_defconfig            |    2 +-

Acked-by: Paul Mundt <lethal@linux-sh.org>
