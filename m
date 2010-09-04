Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0IDVAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 17:00:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5948 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab0IDVAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 17:00:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Sat, 04 Sep 2010 14:00:49 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
Date: Sat, 4 Sep 2010 14:00:47 -0700
Subject: RE: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC
Thread-Topic: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC
Thread-Index: ActKxwIBBnzxwJVZSYKXlKyFZknAnQBrTIyg
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702CF4B651C@HQMAIL01.nvidia.com>
References: <1283448586-14613-1-git-send-email-rklein@nvidia.com>
 <20100902174736.GA28649@oksana.dev.rtsoft.ru>
In-Reply-To: <20100902174736.GA28649@oksana.dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o84L12an027688

Mark, have you had a chance to double check my changes based on the comments you made? 

Thanks,
Rhyland

-----Original Message-----
From: Anton Vorontsov [mailto:cbouatmailru@gmail.com] 
Sent: Thursday, September 02, 2010 10:48 AM
To: Rhyland Klein
Cc: linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org; olof@lixom.net; Andrew Chew; khali@linux-fr.org; broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC

On Thu, Sep 02, 2010 at 10:29:46AM -0700, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> this driver depends on I2C and uses SMBUS for communication with the host.
> 
> Addressed comments from reviews by Mark Brown and Jean Delvare.
>   * Cleaned up whitespace and alignment issues
>   * changed return codes to more appropriate values
>   * change Kconfig option name to be consistent with existing devices
>   * removed global struct and moved to device specific data
>   * changed printk to dev_dbg

The driver looks good to me. But I'll wait a day or two for Jean's
and Mark's Acked-by or Reviewed-by tags before applying, just to
give them some credit for reviwing this driver.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
