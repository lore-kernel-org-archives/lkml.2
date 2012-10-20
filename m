Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab2JTCbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 22:31:41 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:34464 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab2JTCbg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 22:31:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>, "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
CC: Brett Rudley <brudley@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>, Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Luciano Coelho <coelho@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Date: Fri, 19 Oct 2012 19:30:06 -0700
Subject: RE: [PATCH net-next 04/21] wireless: Convert is_<foo>_ether_addr
 uses to eth_addr_<foo>
Thread-Topic: [PATCH net-next 04/21] wireless: Convert is_<foo>_ether_addr
 uses to eth_addr_<foo>
Thread-Index: Ac2trj+3nZSdyF8JSRme/uOrnQNJRwAvEpWA
Message-ID: <477F20668A386D41ADCC57781B1F7043083B8EC57E@SC-VEXCH1.marvell.com>
References: <cover.1350618006.git.joe@perches.com>
 <bb2235c257e347354d94478bd1be35b89bf90186.1350618009.git.joe@perches.com>
In-Reply-To: <bb2235c257e347354d94478bd1be35b89bf90186.1350618009.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> Subject: [PATCH net-next 04/21] wireless: Convert is_<foo>_ether_addr uses to eth_addr_<foo>
> 
> Convert the old ether_addr tests to eth_addr_<foo>.
> Adds api consistency.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Bing Zhao <bzhao@marvell.com> [mwifiex]

Thanks,
Bing
