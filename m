Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab2KZSNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:13:52 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:37859 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab2KZSNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:13:48 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1353953626!7457827!4
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Nov 2012 12:13:38 -0600
Subject: build failure next-20121126
Thread-Topic: build failure next-20121126
Thread-Index: Ac3MAar+xV4SXxcBQked1U0b2/UkGg==
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B2645A2F@AUSP01VMBX24.collaborationhost.net>
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

Hello all,

Another build failure with next-20121126:

  CC      security/integrity/evm/evm_secfs.o
In function 'copy_from_user',
    inlined from 'evm_write_key' at security/integrity/evm/evm_secfs.c:71:
/home/bigguiness/src/git/linux-next/arch/x86/include/asm/uaccess_32.h:211: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct
make[3]: *** [security/integrity/evm/evm_secfs.o] Error 1
make[2]: *** [security/integrity/evm] Error 2
make[1]: *** [security/integrity] Error 2
make: *** [security] Error 2

Regards,
Hartley

