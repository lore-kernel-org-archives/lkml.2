Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0LIOfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 09:35:23 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:33907 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800Ab0LIOfW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 09:35:22 -0500
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 9 Dec 2010 15:35:05 +0100
Subject: RE: [PATCH 01/20] mfd/ab8500: remove spi support
Thread-Topic: [PATCH 01/20] mfd/ab8500: remove spi support
Thread-Index: AcuXrXbtY0gJxwtNRe+ppPhaVL2vbgAACbeA
Message-ID: <33A307AF30D7BF4F811B1568FE7A9B18047C7D405F@EXDCVYMBSTM006.EQ1STM.local>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
 <1291388753-14662-2-git-send-email-sundar.iyer@stericsson.com>
 <20101209142912.GM8884@sortiz-mobl>
In-Reply-To: <20101209142912.GM8884@sortiz-mobl>
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

Hi Sam,

[pruning up the CC list]

>-----Original Message-----
>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>
>> Since the Ab8500 v1.0, the SPI support is deprecated on the HW.
>I'm fine with that, but you really don't want to be able to support pre 1.0
>devices ?

AFAIK, there aren't active pieces of those outside STE :) and it is accepted
that we drop the support for them.

Cheers!
