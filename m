Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab1FVLmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:42:13 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:31908
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757643Ab1FVLmK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:42:10 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH 5/7] powerpc/85xx: add board support for the Freescale hypervisor
MIME-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1305813272-31826-6-git-send-email-timur@freescale.com>
Date: Wed, 22 Jun 2011 06:42:00 -0500
CC: <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <5853C1C3-ADAF-4F6E-A675-F4DEF7162B38@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com> <1305813272-31826-6-git-send-email-timur@freescale.com>
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.1084)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 19, 2011, at 8:54 AM, Timur Tabi wrote:

> Add support for the ePAPR-compliant Freescale hypervisor (aka "Topaz") on the
> Freescale P3041DS, P4080DS, and P5020DS reference boards.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> arch/powerpc/platforms/85xx/Kconfig      |    3 +++
> arch/powerpc/platforms/85xx/corenet_ds.c |    7 +++++++
> arch/powerpc/platforms/85xx/p3041_ds.c   |   16 +++++++++++++++-
> arch/powerpc/platforms/85xx/p4080_ds.c   |   29 ++++++++++++++++-------------
> arch/powerpc/platforms/85xx/p5020_ds.c   |   16 +++++++++++++++-
> 5 files changed, 56 insertions(+), 15 deletions(-)

applied to next

- k
