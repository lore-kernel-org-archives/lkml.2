Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0EYHDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:03:21 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:48108 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114Ab0EYHDT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:03:19 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 25 May 2010 09:02:57 +0200
Subject: RE: ab3100-otp: fix memory leak in ab3100_otp_probe
Thread-Topic: ab3100-otp: fix memory leak in ab3100_otp_probe
Thread-Index: Acr71jucx6gsQzdmRMC6n7fkLGEDcwAAf05g
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A7D7702@EXDCVYMBSTM006.EQ1STM.local>
References: <1274770191.6998.3.camel@mola>
In-Reply-To: <1274770191.6998.3.camel@mola>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Axel]

> In current implementation, there is a memory leak if ab3100_otp_read fail.
> And in the case of ab3100_otp_init_debugfs fail, it does not properly
> remove
> sysfs entries.
> This patch properly handle above failure cases.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Thanks for fixing this!

Yours,
Linus Walleij
