Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2GCJFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:05:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57605 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2GCJFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:05:40 -0400
Subject: Re: BNX2 MIPS06 firmware in tree is 6.2.1, driver wants 6.2.3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tony Vroon <tony@linx.net>
Cc: Michael Chan <mchan@broadcom.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Anthony G. Basile" <basile@virtual.dyc.edu>
In-Reply-To: <4FF2B263.4080000@linx.net>
References: <4FF2B263.4080000@linx.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Jul 2012 11:05:34 +0200
Message-ID: <1341306334.2583.81.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 09:50 +0100, Tony Vroon wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Good morning,
> 
> As of mainline commit c2c20ef43d00b1439631e603f8dcee9a803cd8b3 in
> December 2011, the BNX2 driver requests bnx2/bnx2-mips-06-6.2.3.fw;
> however the firmware/bnx2 directory in the kernel sources only
> contains bnx2/bnx2-mips-06-6.2.1.fw so the call fails.
> 
> The network interfaces will not come up at all, making it necessary to
> steal & rename 6.2.1 firmware to get the interfaces up, and then
> install a linux-firmware tarball. Before this commit, the bnx2 driver
> as compiled was self-sufficient.
> 
> Would it be possible to get back to this situation by updating the
> relevant firmware/bnx2 files in the kernel sources please? I noticed
> this problem in an upgrade from 3.2.11 to 3.4.2, but I verified it is
> still an issue in mainline today.

You're supposed to upgrade firmware blobs on your own.

http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=summary



