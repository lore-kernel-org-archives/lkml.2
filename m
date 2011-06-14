Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1FNIxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:53:37 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37872 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755310Ab1FNIxf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:53:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 14 Jun 2011 01:46:04 -0700
Subject: RE: [PATCH net-next 1/2] wireless: Remove casts of void *
Thread-Topic: [PATCH net-next 1/2] wireless: Remove casts of void *
Thread-Index: AcwqSB0hynOHU1ogTk+s/ST3G7dy2QAJ2Gkb
Message-ID: <477F20668A386D41ADCC57781B1F704307FF7C4650@SC-VEXCH1.marvell.com>
References: <cover.1308024069.git.joe@perches.com>,<337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
In-Reply-To: <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - pt = (T *)pv;
> + pt = pv;
> 
> Signed-off-by: Joe Perches joe@perches.com
...
> drivers/net/wireless/mwifiex/11n.c             |    5 ++---
> drivers/net/wireless/mwifiex/cmdevt.c          |    3 +--
> drivers/net/wireless/mwifiex/join.c            |    2 +-
> drivers/net/wireless/mwifiex/scan.c            |    2 +-
> drivers/net/wireless/mwifiex/sta_cmd.c         |    4 ++--
> drivers/net/wireless/mwifiex/sta_cmdresp.c     |   12 ++++++------
> drivers/net/wireless/mwifiex/txrx.c            |    2 +-
> drivers/net/wireless/p54/eeprom.c              |    4 ++--
> 22 files changed, 41 insertions(+), 47 deletions(-)

For mwifiex part, Acked-by: Bing Zhao bzhao@marvell.com

Thanks,
Bing