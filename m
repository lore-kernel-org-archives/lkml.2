Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab0GMOfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:35:13 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:54413 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883Ab0GMOfL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:35:11 -0400
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Date: Tue, 13 Jul 2010 16:34:56 +0200
Subject: RE: [PATCH v2 1/2] regulator: add support for regulators on the
 ab8500 MFD
Thread-Topic: [PATCH v2 1/2] regulator: add support for regulators on the
 ab8500 MFD
Thread-Index: AcsilhcQ0tdNu3arQAShUDPsIMvs2wAAXmEA
Message-ID: <33A307AF30D7BF4F811B1568FE7A9B1810E7E880@EXDCVYMBSTM006.EQ1STM.local>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <20100713141709.GA24260@rakim.wolfsonmicro.main>
In-Reply-To: <20100713141709.GA24260@rakim.wolfsonmicro.main>
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

Hello Mark,

>> + * @mask: mask to enable/disable regulator
>> + * @enable: bits to enable the regulator in normal(high power) mode
>Have you addressed my comments here?
Sorry that I couldn't inline my replies into the patch itself :(. I changed the comments for the variable
from the previous patch set. But I agree I messed up!

Yes. The mask here is different for the fact that we have two enable bits; enable LP(low power)
mode and enable HP(high power). We enable only the HP modes and hence the different mask
for enable/disable as well as for the enable.

>> +	ret = ab8500_get_best_voltage_index(rdev, min_uV, max_uV);
>> +	if (ret < 0) {
>> +		dev_dbg(rdev_get_dev(rdev),
>> +				"coudlnt get best voltage for regulator\n");
>
>Typo here.  Also, shouldn't your error messages be errors rather than
>debug output?
Yes. I will correct this.
