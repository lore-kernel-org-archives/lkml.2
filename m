Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1AYKA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:00:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1AYKA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:00:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4 01/19] ARM: Make the argument to virt_to_phys() "const volatile"
Date: Tue, 25 Jan 2011 11:00:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-2-git-send-email-catalin.marinas@arm.com> <4D3DD0D8.10905@codeaurora.org>
In-Reply-To: <4D3DD0D8.10905@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201101251100.11052.arnd@arndb.de>
X-Provags-ID: V02:K0:P0WCNr0vogTp2rLztQCwzJOodIe3RxTFKPG7gq3nHZm
 7SIOJ4he4LSx2ngNRkvDaNbgiErh5pwgYnweiLZ74J5kuIuLvr
 S/Isa2IOGwgbWddbBO2TQisJe7CxG/hRn6vOLUOCNfacBnEwkf
 fzdr4+EUMVVV8ag1i85B9AK7T1i1xLSNDdzxZIqkuQ7XmF3ggs
 rAtJltf/qQJyPYvaoz0iQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 January 2011, Stephen Boyd wrote:
> On 01/24/2011 09:55 AM, Catalin Marinas wrote:
> > Changing the virt_to_phys() argument to "const volatile void *" avoids
> > compiler warnings in some situations where this function is used.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> Acked-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Any chance we can get this one patch into 2.6.38? It fixes a warning for
> MSM.

Stephen, you might want to have a look at why the warning even appears
on MSM. Most uses of 'volatile' are misguided, and there could be an
actual bug in there.

	Arnd
