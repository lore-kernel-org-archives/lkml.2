Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab0HKL0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 07:26:42 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:38525 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab0HKL0l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 07:26:41 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Julia Lawall <julia@diku.dk>, Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 11 Aug 2010 13:22:36 +0200
Subject: RE: [PATCH 2/5] drivers/dma: Return -ENOMEM on memory allocation
 failure
Thread-Topic: [PATCH 2/5] drivers/dma: Return -ENOMEM on memory allocation
 failure
Thread-Index: Acs5PYYBCsAqRLweRzGzCEY1ym32DQACd0sA
Message-ID: <CEE6BB42CAD6E947908279175AF8470A0262F4A8EF@EXDCVYMBSTM006.EQ1STM.local>
References: <Pine.LNX.4.64.1008111210490.8669@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008111210490.8669@ask.diku.dk>
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

> From: Julia Lawall <julia@diku.dk>
> 
> In this code, 0 is returned on memory allocation failure, even though
> other failures return -ENOMEM or other similar values.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Thanks for fixing this Julia!

Yours,
Linus Walleij
