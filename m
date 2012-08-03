Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab2HCERI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 00:17:08 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:40792 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769Ab2HCERF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 00:17:05 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.6-rc1:     twl4030  don't compile   :(
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 03 Aug 2012 00:17:01 -0400
Message-ID: <web-777065796@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   CC      drivers/power/twl4030_charger.o
drivers/power/twl4030_charger.c:248:12: error: invalid 
suffix "b1100" on integer constant
drivers/power/twl4030_charger.c:250:12: error: invalid 
suffix "b1000" on integer constant
drivers/power/twl4030_charger.c:252:12: error: invalid 
suffix "b0100" on integer constant
drivers/power/twl4030_charger.c:254:12: error: invalid 
suffix "b0000" on integer constant
drivers/power/twl4030_charger.c:257:12: error: invalid 
suffix "b11" on integer constant
drivers/power/twl4030_charger.c:259:12: error: invalid 
suffix "b10" on integer constant
drivers/power/twl4030_charger.c:261:12: error: invalid 
suffix "b01" on integer constant
drivers/power/twl4030_charger.c:263:12: error: invalid 
suffix "b00" on integer constant
drivers/power/twl4030_charger.c:266:5: error: invalid 
suffix "b1100" on integer constant
drivers/power/twl4030_charger.c:266:26: error: invalid 
suffix "b11" on integer constant
make[2]: [drivers/power/twl4030_charger.o] Error 1 
(ignored)
   CC      drivers/power/lp8727_charger.o
   CC      drivers/power/gpio-charger.o
   CC      drivers/power/charger-manager.o
   LD      drivers/power/avs/built-in.o
   CC      drivers/power/smb347-charger.o
   LD      drivers/power/built-in.o
ld: drivers/power/twl4030_charger.o: No such file: No such 
file or directory
make[2]: [drivers/power/built-in.o] Error 1 (ignored)
   CC [M]  drivers/power/ds2760_battery.o

....  that messed the whole compilation because the kernel 
didn't link   :(  :(
---
Professional hosting for everyone - http://www.host.ru
