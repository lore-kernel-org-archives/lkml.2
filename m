Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2DCMk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:40:29 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:33281
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab2DCMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:40:27 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh2a8h668h839h93fhd24hd2bh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Regmap group read and write issue for special case of PMIC
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <linux-kernel@vger.kernel.org>
CC: <broonie@opensource.wolfsonmicro.com>, <Anthony.Olech@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 3 Apr 2012 18:05:39 +0530
Message-ID: <1333456539.24292.24.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

DA9052/53 PMIC in SPI mode does not support group read and write but in
I2C mode group read and write are supported.

This special case of DA9052/53 like PMIC needs to be handled in the
regmap. For this can we, in regmap introduce a new flag and its value
determines whether to translate internally, the regmap group read and
write call into a series of single read and write calls Or not?

Regards,
Ashish


