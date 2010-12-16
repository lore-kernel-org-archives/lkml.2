Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0LPHbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 02:31:41 -0500
Received: from relay02.digicable.hu ([92.249.128.188]:52777 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0LPHbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 02:31:38 -0500
Message-ID: <4D09C056.5020305@freemail.hu>
Date: Thu, 16 Dec 2010 08:31:34 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: gregkh <gregkh@suse.de>, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: usbip: somtimes stalls at kernel_recvmsg()
References: <4D06A004.8070502@freemail.hu>
In-Reply-To: <4D06A004.8070502@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.98.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> I'm working with usbip and I sometimes see a stall when I run
> the "lsusb" command from the userspace. I added some debug messages
> and it seems that the kernel_recvmsg() in
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/staging/usbip/usbip_common.c;h=210ef16bab8d271a52e5d36cd1994aad57ad99e1;hb=HEAD
> 
> This is the only place I could find where the TCP messages are arriving in
> the usbip code.
> 
> What happens if a message does not arrive? Does it stall forever? If
> yes, how can the kernel_recvmsg() call changed to handle some timeout?

I found that the userspace manpage of recvmsg(2) ("man recvmsg") contains description
of the "flags" parameter. I suppose the parameters and behaviour of the userspace
recvmsg() is the same as the kernelspace kernel_recvmsg().


	Márton Németh
