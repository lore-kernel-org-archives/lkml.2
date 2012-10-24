Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab2JXMEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:04:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56664 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2JXMEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:04:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v3 1/5] zynq: use GIC device tree bindings
Date: Wed, 24 Oct 2012 12:03:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>
References: <20121024003353.GB31625@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024003353.GB31625@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241203.53946.arnd@arndb.de>
X-Provags-ID: V02:K0:WY/FcbA3QQksx1Npj7NT04Y5NzRNoO9p8XtUtaw9j6L
 beBcXBFSxEtSapgBJH5m02ce6QU8TeJyfDZ0i1KDPYp5dWHsJX
 QLCRl54hs10gQ4gvCsL/hL+TL9IyCZqZoQMSYBdTqzf+WFacbk
 W8vtj0DppOXvSLUid90T0mCMDraMtDteHs9oers9iYmq0gX7Rk
 kp2YeANTz6Uc5bbGpO1rq40K4HlIqW2XMoGe9r0Ouh/EfX0+ZT
 OMuQDMEGEILpEkmkzb9frhtw1X9IB7Zvvb6292b4n6udMMnSp9
 DgZ0xoKz5yxIgU7YDuA3duaL9DW5g3n5U2sSkoaH+HOq9R7FjD
 Jgw+IyfnGJQUu5f9czg4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Josh Cartwright wrote:
> The Zynq uses the cortex-a9-gic.  This eliminates the need to hardcode
> register addresses.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
