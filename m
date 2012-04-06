Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab2DFAgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:36:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55917 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2DFAgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:36:06 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 5 Apr 2012 17:36:02 -0700
Subject: Question about the regulator driver
Thread-Topic: Question about the regulator driver
Thread-Index: Ac0TjT7FICmcGCFIQH62GHhQ0W1Stw==
Message-ID: <B567DBAB974C0544994013492B949F8E38135B639C@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a question about the regulator driver design.

There is a mfd device including charger and regulator functions.

For supporting DCDC(or BUCK) and LDO functions, the regulator driver is used.
(like setting voltage, current limit and so on)
On the other hand, the charger module is registered as the power supply class driver.

But charging termination voltage and charging current can be configurable in the charger operation.
In that case, is it common to add regulator_ops for the charger ?
Or is it better that charging parameters are set only in the power supply driver ?

I'd like to have your opinion.

Thanks & BR
Milo -

