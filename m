Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab0LMWg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:36:58 -0500
Received: from relay03.digicable.hu ([92.249.128.185]:57645 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0LMWg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:36:57 -0500
Message-ID: <4D06A004.8070502@freemail.hu>
Date: Mon, 13 Dec 2010 23:36:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: gregkh <gregkh@suse.de>, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: usbip: somtimes stalls at kernel_recvmsg()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 78.131.104.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working with usbip and I sometimes see a stall when I run
the "lsusb" command from the userspace. I added some debug messages
and it seems that the kernel_recvmsg() in
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/staging/usbip/usbip_common.c;h=210ef16bab8d271a52e5d36cd1994aad57ad99e1;hb=HEAD

This is the only place I could find where the TCP messages are arriving in
the usbip code.

What happens if a message does not arrive? Does it stall forever? If
yes, how can the kernel_recvmsg() call changed to handle some timeout?

	Márton Németh
