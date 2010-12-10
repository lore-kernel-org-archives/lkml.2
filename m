Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0LJPJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:09:19 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:43150
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558Ab0LJPJS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:09:18 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zzbb2cK1432N148cM1127izz1202hzz8275bh8275chz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:WCSSRV0099.ad.wabtec.com;RD:none;EFVD:NLI
From: <BGardner@Wabtec.com>
To: <dilinger@queued.net>, <akpm@linux-foundation.org>
CC: <dsd@laptop.org>, <linux-kernel@vger.kernel.org>,
        <linux-geode@lists.infradead.org>
Date: Fri, 10 Dec 2010 10:09:11 -0500
Subject: RE: [PATCH] cs5535: deprecate older cs5535_gpio driver
Thread-Topic: [PATCH] cs5535: deprecate older cs5535_gpio driver
Thread-Index: AcuX48OAGatQ4geFQMWH6vo+ProvxwAlptRQ
Message-ID: <A6D0FB5E86AC4240806BC05703DF2729C9925C79@WABTECE2007.ad.wabtec.com>
References: <20101209125737.065e91fd@queued.net>
In-Reply-To: <20101209125737.065e91fd@queued.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: wabtec.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The newer drivers/gpio/cs5535-gpio.c replaces
> drivers/misc/cs5535_gpio.c.  The new driver has been in the tree
> for a little while, and has received some testing; it's time to mark
> the old one as deprecated.  I'm thinking removal around 2.6.40 would
> be good, provided we're not missing critical functionality in the
> newer driver.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: Ben Gardner <bgardner@wabtec.com>

Thanks for taking care of this.

Ben
This email and any attachments are only for use by the intended recipient(s) and may contain legally privileged, confidential, proprietary or otherwise private information.  Any unauthorized use, reproduction, dissemination, distribution or other disclosure of the contents of this e-mail or its attachments is strictly prohibited.  If you have received this email in error, please notify the sender immediately and delete the original.


