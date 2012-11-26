Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab2KZRw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:52:56 -0500
Received: from mail160.messagelabs.com ([216.82.253.99]:13724 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2KZRwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:52:54 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1353952370!8478773!14
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Nov 2012 11:52:25 -0600
Subject: build failure next-20121126
Thread-Topic: build failure next-20121126
Thread-Index: Ac3L/py0jviqVcw3QB+PLII0sxa1xg==
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B2645A0F@AUSP01VMBX24.collaborationhost.net>
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

I was just trying a allyesconfig build of next-20121126 and got this:

  CC      fs/cifs/cifs_debug.o
In function 'copy_from_user',
    inlined from 'cifs_security_flags_proc_write' at fs/cifs/cifs_debug.c:593:
/home/bigguiness/src/git/linux-next/arch/x86/include/asm/uaccess_32.h:211: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct
make[2]: *** [fs/cifs/cifs_debug.o] Error 1
make[1]: *** [fs/cifs] Error 2
make: *** [fs] Error 2

I'm not sure if this is a known issue...

Regards,
Hartley

