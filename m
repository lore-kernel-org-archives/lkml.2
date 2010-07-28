Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0G1RZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:25:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22249 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0G1RZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:25:55 -0400
Date: Wed, 28 Jul 2010 10:24:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lirc-list@lists.sourceforge.net,
        Jarod Wilson <jarod@wilsonet.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: Tree for July 28 (lirc #2)
Message-Id: <20100728102417.be60049a.randy.dunlap@oracle.com>
In-Reply-To: <20100728162855.4968e561.sfr@canb.auug.org.au>
References: <20100728162855.4968e561.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C506806.00E2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 16:28:55 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100727:


When USB_SUPPORT is not enabled and MEDIA_SUPPORT is not enabled:


ERROR: "lirc_dev_fop_close" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_dev_fop_open" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_dev_fop_poll" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_dev_fop_write" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_dev_fop_read" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_register_driver" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_register_driver" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_string" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_alloc_coherent" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_dev_fop_ioctl" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_get_pdata" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_free_coherent" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_free_urb" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_unregister_driver" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_kill_urb" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_submit_urb" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "usb_deregister" [drivers/staging/lirc/lirc_streamzap.ko] undefined!
ERROR: "lirc_dev_fop_close" [drivers/staging/lirc/lirc_sir.ko] undefined!
ERROR: "lirc_dev_fop_open" [drivers/staging/lirc/lirc_sir.ko] undefined!
ERROR: "lirc_register_driver" [drivers/staging/lirc/lirc_sir.ko] undefined!
ERROR: "lirc_unregister_driver" [drivers/staging/lirc/lirc_sir.ko] undefined!

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
