Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2GCJa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:30:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46121 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab2GCJa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:30:57 -0400
Subject: Re: BNX2 MIPS06 firmware in tree is 6.2.1, driver wants 6.2.3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tony Vroon <tony@linx.net>
Cc: Michael Chan <mchan@broadcom.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Anthony G. Basile" <basile@virtual.dyc.edu>
In-Reply-To: <4FF2B64A.5020002@linx.net>
References: <4FF2B263.4080000@linx.net>
	 <1341306334.2583.81.camel@edumazet-glaptop>  <4FF2B64A.5020002@linx.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Jul 2012 11:30:52 +0200
Message-ID: <1341307852.2583.123.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 10:07 +0100, Tony Vroon wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 03/07/12 10:05, Eric Dumazet wrote:
> > You're supposed to upgrade firmware blobs on your own.
> 
> But the firmware is in the kernel tree still, should the outdated
> files be removed?

I believe firmware/README.AddingFirmware contains the rationale.


