Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1ADGSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:18:25 -0500
Received: from gherkin.frus.com ([192.158.254.49]:53964 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1ADGSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:18:23 -0500
Date: Tue, 4 Jan 2011 00:18:21 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Cc: mcree@orcon.net.nz
Subject: [BUG] implicit declaration of kfree/kzalloc in i2c-i801.c on Alpha
Message-ID: <20110104061821.GA25886@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another 2.6.37-rc8 build failure on alpha:

(...)
  CC [M]  drivers/i2c/busses/i2c-i801.o
drivers/i2c/busses/i2c-i801.c: In function 'i801_probe':
drivers/i2c/busses/i2c-i801.c:737: error: implicit declaration of function 'kzalloc'
drivers/i2c/busses/i2c-i801.c:737: warning: assignment makes pointer from integer without a cast
drivers/i2c/busses/i2c-i801.c:855: error: implicit declaration of function 'kfree'
make[3]: *** [drivers/i2c/busses/i2c-i801.o] Error 1
make[2]: *** [drivers/i2c/busses] Error 2
make[1]: *** [drivers/i2c] Error 2
make: *** [drivers] Error 2

--Bob
