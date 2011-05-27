Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1E0M3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:29:38 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:32394 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1E0M3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:29:33 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH] drivers/misc: add Kbuild header file entry for Freescale hypervisor management driver
MIME-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1306450501-29583-1-git-send-email-timur@freescale.com>
Date: Fri, 27 May 2011 07:29:32 -0500
CC: <akpm@linux-foundation.org>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <C2A71BA0-B229-4D44-8472-3ABEE6A54F21@freescale.com>
References: <1306450501-29583-1-git-send-email-timur@freescale.com>
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.1084)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 26, 2011, at 5:55 PM, Timur Tabi wrote:

> fsl_hypervisor.h includes an ioctl interface, so it should be made available
> via "make headers_install".
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> 
> This adds one change that I forgot to include in my previous patch,
> "drivers/misc: introduce Freescale hypervisor management driver".
> 
> Kumar, if at all possible, please squash this patch into that one.
> 
> include/linux/Kbuild |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)

Just repost the patch you want this merged in.

- k
