Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2DIRSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:18:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57532 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751672Ab2DIRSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:18:02 -0400
X-Authenticated: #117848833
X-Provags-ID: V01U2FsdGVkX19QuwUd3chQuyfq+Zr8ABZ2scPFvqJ43pdbGZr0CB
	9xQgvCQmsmhuDP
Date: Mon, 9 Apr 2012 19:17:56 +0200
From: "B. K. Lohse" <lolium@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: [Regression]: Bluetooth: btusb: hci command tx timeout
Message-Id: <20120409191756.f6eeea4e.lolium@gmx.net>
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
since Linux 2.6.29 my integrated Bluetooth hostcontroller does not work
anymore. Its a hardwired Broadcom chip connected via USB in an IBM
Thinkpad T43 and supported by btusb.

While scanning for devices and pairing mostly succeeds, the process
stalls after that repeatable, so its impossible to use the connection.
Kernel message buffer shows:

Bluetooth: hci0 link tx timeout
Bluetooth: killing stalled connection XX:XX:XX:XX:XX:XX

Verified with bluetooth mouse, cellphone and another linuxbox with
bluez, kernel 2.6.30-3.4-rc1, bluez 4.96, 4.98, 4.99, git.

Adapter information:
[*] lsusb
ID: 0a5c:201e Broadcom Corp. IBM Integrated Bluetooth IV
[*] hciconfig -a
hci0:	Type: BR/EDR  Bus: USB
	BD Address: 00:0E:9B:XX:XX:XX  ACL MTU: 377:10  SCO MTU: 64:8
	UP RUNNING PSCAN 
	RX bytes:1839 acl:0 sco:0 events:56 errors:0
	TX bytes:509 acl:0 sco:0 commands:56 errors:0
	Features: 0xff 0xfe 0x0d 0x38 0x08 0x08 0x00 0x00
	Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3 
	Link policy: 
	Link mode: SLAVE ACCEPT 
	Name: 'xxx'
	Class: 0x420100
	Service Classes: Networking, Telephony
	Device Class: Computer, Uncategorized
	HCI Version: 1.2 (0x2)  Revision: 0x9
	LMP Version: 1.2 (0x2)  Subversion: 0x6963
	Manufacturer: Broadcom Corporation (15)

Would be great if someone investigates that issue further.

Sincerely yours
Burkhard


You can email me directly, too: lolium {replace-with-at-sign} gmx.net 
