Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1KIIPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:15:04 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:8729
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429Ab1KIIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:15:03 -0500
X-SpamScore: 7
X-BigFish: VPS7(zzzz1202h10d2nzzz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 0,13,
Subject: Adding USB charge current property in the Linux Battery core
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <linaro-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <eric.miao@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 9 Nov 2011 13:43:37 +0530
Message-ID: <1320826417.1160.8.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.22]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

For a better performance in USB charging operation, the DA9052/53 charging
current can be configured in accordance with the USB host current
delivering capacity (known through USB drivers negotiation).
 
To implement this useful feature, a new writable property "USB charge current"
needs to be added in the Linux battery core.

Let me know your views on it.

Regards,
Ashish


