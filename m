Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2ALPp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:45:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44413 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2ALPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:45:51 -0500
Message-ID: <1326383147.2950.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: bnx2-mips-09-6.2.1.b still missing
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Michael Chan <mchan@broadcom.com>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jan 2012 16:45:47 +0100
In-Reply-To: <CAAJw_Zte4JSFeb9zK4gtptBq=H1RoqaSgaV3OpmxuXBY5cZByA@mail.gmail.com>
References: <CAAJw_Zte4JSFeb9zK4gtptBq=H1RoqaSgaV3OpmxuXBY5cZByA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 janvier 2012 à 23:31 +0800, Jeff Chua a écrit :
> commit c2c20ef43d00b1439631e603f8dcee9a803cd8b3 mentioned
> bnx2-mips-09-6.2.1.b, but it's still missing from the latest git.
> Where can I download the bnx2 firmware from?
> 
> Thanks,
> Jeff
> 

http://git2.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=summary

commit 9897fdba8c422615695af7be3a3d42db46d35620
Author: Michael Chan <mchan@broadcom.com>
Date:   Sun Dec 18 20:13:32 2011 -0800

    linux-firmware: bnx2: Update mips firmware to fix iSCSI problems
    
    New firmware fixes iSCSI problems with some LeftHand targets that
don't
    set TTT=0xffffffff for Data-In according to spec.  Firmware
generates
    exception warnings for this condition and becomes very slow.  This
is
    fixed by suppressing these warnings when using default error mask.
    
    Signed-off-by: Michael Chan <mchan@broadcom.com>
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>



