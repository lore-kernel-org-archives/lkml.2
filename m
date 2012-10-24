Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab2JXMIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:08:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2JXMIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:08:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v3 5/5] zynq: move static peripheral mappings
Date: Wed, 24 Oct 2012 12:08:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>
References: <20121024003523.GF31625@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024003523.GF31625@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241208.30768.arnd@arndb.de>
X-Provags-ID: V02:K0:Ihb+OqkVY0Yt+/Rc41vrj3QBKwpSYcNtHNRMhw5Cg1y
 qt6VUQpL2requJQSI800nFAKubhfaWDcupBn4lJvlqSBSHshlP
 i9LtCR4804IrNTSt/e6UTt9MbaZhnOMqYlNxBygceUl4uLvCEN
 CEJm9cE7jpagxMR+WVSJA0N7C5i7DJNSFXR9lTtRsQEPxRsLJL
 Uwr0TNRExCnsTC692YGDbJMSzR7aBZf78tmZYK/DEhWLQzsSwj
 niRNLYCMVTJGfiMTOyDjd4LWx6HSVvgnqCzmG3YP7gUIjyGQtU
 SDXv+lLd7nsRcTBNTNhTAp9NNtKl88XeOqX9WLG5zSSAKZZI6H
 re9lryiuLFu/lDSs9B/s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Josh Cartwright wrote:
> Shifting them up into the vmalloc region prevents the following warning,
> when booting a zynq qemu target with more than 512mb of RAM:
> 
>   BUG: mapping for 0xe0000000 at 0xe0000000 out of vmalloc space
> 
> In addition, it allows for reuse of these mappings when the proper
> drivers issue requests via ioremap().
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
