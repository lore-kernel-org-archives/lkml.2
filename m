Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0F3PUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:20:16 -0400
Received: from client-adsl-93-121-138-180.mediaserv.net ([93.121.138.180]:37412
	"EHLO werner.loopback" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756105Ab0F3PUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:20:13 -0400
X-Greylist: delayed 137404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jun 2010 11:20:11 EDT
From: werner@guyane.yi.org
Subject: Fwd: 2.6.35-rc1   classmate-laptop.c  poroblem
To: linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1277527970.7800@guyane.yi.org>
Date: Sat, 26 Jun 2010 01:52:50 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1277527970"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1277527970
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

On 31/Mai/2010 12:48 werner@sys-linux.yi.org wrote ..
> 
> 
> drivers/built-in.o: In function `cmpc_ipml_remove':
> classmate-laptop.c:(.text+0x671548): undefined reference to `rfkill_unregister'
> classmate-laptop.c:(.text+0x671550): undefined reference to `rfkill_destroy'
> drivers/built-in.o: In function `cmpc_ipml_add':
> classmate-laptop.c:(.text+0x67163f): undefined reference to `rfkill_alloc'
> classmate-laptop.c:(.text+0x671650): undefined reference to `rfkill_register'
> classmate-laptop.c:(.text+0x67165c): undefined reference to `rfkill_destroy'
> drivers/built-in.o: In function `cmpc_rfkill_query':
> classmate-laptop.c:(.text+0x6716db): undefined reference to `rfkill_set_sw_state'
> make: [.tmp_vmlinux1] Error 1 (ignored)

--bound1277527970--

