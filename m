Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1LAM6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:58:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43776 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab1LAM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:58:36 -0500
Message-ID: <1322744304.7477.1.camel@phoenix>
Subject: [linux-next] drivers/i2c/busses/i2c-nuc900.c build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Thu, 01 Dec 2011 20:58:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I got below build error on linux-next 20111201.
  CC      drivers/i2c/busses/i2c-nuc900.o
drivers/i2c/busses/i2c-nuc900.c: In function 'nuc900_i2c_probe':
drivers/i2c/busses/i2c-nuc900.c:600: error: request for member 'apbfreq' in something not a structure or union
make[3]: *** [drivers/i2c/busses/i2c-nuc900.o] Error 1
make[2]: *** [drivers/i2c/busses] Error 2
make[1]: *** [drivers/i2c] Error 2
make: *** [drivers] Error 2

Regards,
Axel


