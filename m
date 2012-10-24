Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab2JXMIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:08:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54261 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2JXMIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:08:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v3 4/5] ARM: annotate VMALLOC_END definition with _AC
Date: Wed, 24 Oct 2012 12:07:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>
References: <20121024003502.GE31625@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024003502.GE31625@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241207.56415.arnd@arndb.de>
X-Provags-ID: V02:K0:KK2zhdPhIL2E/z3WV4Y+d/NCcSlM7/yKfKtka0k/p15
 JEaQbWsU9tABWijpYaaUCnYsPTXNxtW3L95bP5N1DKiZIiAJzo
 2J1Grt3GS/36EMqvOJ4OcFEqz3CN4K9VlsiZG9Z3UqdY/C5+EM
 T4E8KkBtX2+ZHZ15/O/ClwFAANG/pXUBMn5c45p/aUov6TGyvp
 oTmINa2B37RUDluuIx6jqX/mpVhOAIXLR39kZYdipB+OHgmBCf
 QIhhP4zMvWPXzwbxwBtNyap8v9HVevOSs2PQSI4QMux0iKXAtd
 QpheL5MgyfNqWCiK3o2M5VTw8ztyd6DHiwkiIuhpqIM6sWKG9H
 +TdDOfwn2KWt0R253qoE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Josh Cartwright wrote:
> This makes the definition of VMALLOC_END suitable for use within
> assembly code.  This is necessary to allow the use of VMALLOC_END in
> defining where the early uart is mapped for use with DEBUG_LL.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
