Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975Ab0J0Ll0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:41:26 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:21285 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760854Ab0J0LlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:41:23 -0400
Message-ID: <00dc01cb75cb$e0ca3430$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Dave Airlie" <airlied@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <socketcan-core@lists.berlios.de>, <sameo@linux.intel.com>,
        <21cnbao@gmail.com>, <chripell@fsfe.org>, <w.sang@pengutronix.de>,
        <wg@grandegger.com>, "David Miller" <davem@davemloft.net>,
        <margie.foster@intel.com>, <kok.howg.ewe@intel.com>,
        <joel.clark@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <yong.y.wang@intel.com>, <qi.wang@intel.com>
References: <4CC61B1B.3090602@dsn.okisemi.com><20101026.105206.15244527.davem@davemloft.net><002801cb758f$876aaf00$66f8800a@maildom.okisemi.com> <AANLkTi=bJTMhEo2agsMJ8fptNp7suERCGkzybb5m7ggg@mail.gmail.com>
Subject: Re: can: About Socket CAN with MSI issue
Date: Wed, 27 Oct 2010 20:41:21 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 27, 2010 4:56 PM, Dave Airlie wrote:
> Its a bug in the PCI layer most likely,

Thank you for your information.

This issue occurrs with Socket-CAN driver only.
Previous version our CAN driver(Not Socket-CAN but Tolapai ) works well.
Thus, IMHO, PCI layer doesn't related to the issue.

Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)
