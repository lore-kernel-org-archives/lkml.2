Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1HKTPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:15:04 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:46005 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751984Ab1HKTPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:15:01 -0400
Date: Thu, 11 Aug 2011 12:14:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: linux-next: Tree for Aug 11 (sound/soc + regmap)
Message-Id: <20110811121459.b235aff5.rdunlap@xenotime.net>
In-Reply-To: <20110811162058.42b462bc80e67d7a80ecff93@canb.auug.org.au>
References: <20110811162058.42b462bc80e67d7a80ecff93@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011 16:20:58 +1000 Stephen Rothwell wrote:

> Hi all,

When CONFIG_SPI is not enabled (so REGMAP_SPI is not enabled):
(on i386 and x86_64)

sound/built-in.o: In function `snd_soc_codec_set_cache_io':
(.text+0x85635): undefined reference to `regmap_init_spi'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
