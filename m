Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2GNAtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:49:52 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:47942 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757297Ab2GNAtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:49:50 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 
To: linux-kernel@vger.kernel.org, mjt@tls.msk.ru
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 13 Jul 2012 20:49:45 -0400
Message-ID: <web-769674809@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since years I use the same routine for compile / link / 
package the kernel.  Until now, rdev gave and wrote always 
the boot device in the form /dev/...  , not as the bios 
number. This problem starts now only. So I suppose there 
was anything changed, either on the kernel or in one of 
the kernel-near basic routines (such as, rdev itself)

I agree that the bios device numbers are not good for 
identify installations or devices, as they can change, if 
one change the BIOS boot order, or if one only change via 
F12 the actual boot order, or even if one stick in an usb 
key before booting; specially it changes after one install 
Linux from an USB key.   Just because of this I use the 
/dev/... names for lilo and for the kernel command line.

rdev may be obsolete, but it's one of the oldest functions 
and used in many install systems, so that for 
compatibility it should be kept, nor be changed.

---
Professional hosting for everyone - http://www.host.ru
