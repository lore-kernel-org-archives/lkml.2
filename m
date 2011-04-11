Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1DKHBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:01:19 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:54258
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753050Ab1DKHBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:01:18 -0400
X-Greylist: delayed 2913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 03:01:18 EDT
Message-ID: <4DA29B75.4090401@compulab.co.il>
Date: Mon, 11 Apr 2011 09:11:01 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: wanlong.gao@gmail.com
CC: linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        david.woodhouse@intel.com, akpm@linux-foundation.org,
        u.kleine-koenig@pengutronix.de, mingo@elte.hu, rientjes@google.com,
        nicolas.ferre@atmel.com, eric@eukrea.com, tony@atomide.com,
        santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        ben-linux@fluff.org, sam@ravnborg.org, manuel.lauss@googlemail.com,
        galak@kernel.crashing.org, anton@samba.org, grant.likely@secretlab.ca,
        sfr@canb.auug.org.au, jwboyer@linux.vnet.ibm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] fix build warnings on defconfigs
References: <1302375858-11253-1-git-send-email-wanlong.gao@gmail.com>
In-Reply-To: <1302375858-11253-1-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/11 22:04, wanlong.gao@gmail.com wrote:

> From: Wanlong Gao <wanlong.gao@gmail.com>
>
> Change the BT_L2CAP and BT_SCO defconfigs from 'm' to 'y',
> since BT_L2CAP and BT_SCO had changed to bool configs.
>
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---

For:

>  arch/arm/configs/cm_x2xx_defconfig         |    4 ++--
>  arch/arm/configs/cm_x300_defconfig         |    4 ++--
>  arch/arm/configs/em_x270_defconfig         |    4 ++--

Acked-by: Igor Grinberg <grinberg@compulab.co.il>

-- 
Regards,
Igor.

