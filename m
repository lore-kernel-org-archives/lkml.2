Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1FFG1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 02:27:44 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:1745 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab1FFG1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 02:27:40 -0400
Subject: Re: [PATCH] Fix build warning of the defconfigs
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux@arm.linux.org.uk, vapier@gentoo.org, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        gxt@mprc.pku.edu.cn, david.woodhouse@intel.com,
        akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de,
        mingo@elte.hu, rientjes@google.com, w.sang@pengutronix.de,
        sam@ravnborg.org, manuel.lauss@googlemail.com, anton@samba.org,
        arnd@arndb.de
In-Reply-To: <1306945763-6583-1-git-send-email-wanlong.gao@gmail.com>
References: <1306945763-6583-1-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 06 Jun 2011 08:24:45 +0200
Message-ID: <1307341485.3104.0.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2011 06:24:48.0479 (UTC) FILETIME=[6F740EF0:01CC2412]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 00:29 +0800, Wanlong Gao wrote:
> RTC_CLASS is changed to bool.
> So value 'm' is invalid.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>

<snipp>

>  arch/avr32/configs/atngw100_mrmt_defconfig |    2 +-
>

For the AVR32 related changes.

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp>

-- 
Hans-Christian Egtvedt

