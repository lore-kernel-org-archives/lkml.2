Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1FMXSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:18:16 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2960 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab1FMXSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:18:15 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Jian Peng" <jipeng@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Jian Peng" <jipeng@broadcom.com>
Date: Mon, 13 Jun 2011 16:18:06 -0700
Subject: two false alarms from checkpatch.pl
Thread-Topic: two false alarms from checkpatch.pl
Thread-Index: AcwqICbrpKXr4rE+RUqTZSPNGJ/dZQ==
Message-ID: <E18F441196CA634DB8E1F1C56A50A874572DE7E95F@IRVEXCHCCR01.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 61E8443A62O8361700-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After running "./scripts/checkpatch.pl -F arch/mips/kernel/syscall.c", I got some errors reported on valid lines

ERROR: space prohibited before open square bracket '['
#451: FILE: mips/kernel/syscall.c:451:
+		: [addr] "r" (addr),

This line is valid, and if I remove the space in between, it will report a different error

ERROR: spaces required around that ':' (ctx:ExV)
#448: FILE: mips/kernel/syscall.c:448:
+		:[old] "=&r" (old),
 		^

In another case, it reported

ERROR: trailing statements should be on next line
#515: FILE: mips/kernel/syscall.c:515:
+	while (1);

This is also valid line.

The above two cases are both false alarms, and need to be treated as exceptions in "checkpatch.pl -F".

Thanks,
Jian



