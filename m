Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1BGLid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:38:33 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:29420 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767Ab1BGLic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:38:32 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: <wg@grandegger.com>, <socketcan-core@lists.berlios.de>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1296818921.git.segoon@openwall.com><a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com><20110204124233.GB334@e-circ.dyndns.org> <20110204.130649.112613896.davem@davemloft.net>
Subject: About bittiming calculation result
Date: Mon, 7 Feb 2011 20:38:29 +0900
Message-ID: <5009516791F146C49C73FAC57C437313@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20110204.130649.112613896.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcvEr15DNrIU5ocWQIK1ihJgNcfMNwCCeRWA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question for bittiming-value calculated by Can-core.

In case setting like below,
 - ip link set can0 type can bitrate 800000
 - clock=50MHz
 - Use pch_can

Can-core calculates like below
brp=21
seg1=1
seg2=1
sjw=1
prop_seg=0

Is "prop_seg=0" true ?
seg1/seg2/sjw/prop_seg must be more than 1 ?

Also I can see the following kernel error log.
bitrate error 0.7%

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

