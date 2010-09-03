Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0ICIir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:38:47 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:53798 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755875Ab0ICIip convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:38:45 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Kenneth Heitke <kheitke@codeaurora.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "tsoni@codeaurora.org" <tsoni@codeaurora.org>
Cc: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Sep 2010 10:38:08 +0200
Subject: RE: [PATCH v2 2/2] i2c: QUP based bus driver for Qualcomm MSM
 chipsets
Thread-Topic: [PATCH v2 2/2] i2c: QUP based bus driver for Qualcomm MSM
 chipsets
Thread-Index: ActK9stP3n1GLKWWSDScK0P0zqEYWwAS89OA
Message-ID: <CEE6BB42CAD6E947908279175AF8470A026B35EA9D@EXDCVYMBSTM006.EQ1STM.local>
References: <1283470197-21148-1-git-send-email-kheitke@codeaurora.org>
 <1283470197-21148-3-git-send-email-kheitke@codeaurora.org>
In-Reply-To: <1283470197-21148-3-git-send-email-kheitke@codeaurora.org>
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

[Kenneth]

> From: Kenneth Heitke [mailto:kheitke@codeaurora.org]
> Subject: [PATCH v2 2/2] i2c: QUP based bus driver for Qualcomm MSM
> chipsets
> (...)
> +	dev->one_bit_t = USEC_PER_SEC/pdata->bus_freq;

Maybe you want to use DIV_ROUND_UP() from kernel.h here
to be on the safe side?

Yours,
Linus Walleij
