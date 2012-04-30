Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2D3RoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:44:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41021 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab2D3Rn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:43:58 -0400
Date: Mon, 30 Apr 2012 13:41:48 -0400 (EDT)
Message-Id: <20120430.134148.722408249106132399.davem@davemloft.net>
To: kaffeemonster@googlemail.com
Cc: netdev@vger.kernel.org, benh@kernel.crashing.org, eric.dumazet@gmail.com,
        matt@ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [REGRESSION][PATCH V5 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F9E1CDB.9020104@googlemail.com>
References: <1335753820.20866.27.camel@pasglop>
	<1335759088.20866.32.camel@pasglop>
	<4F9E1CDB.9020104@googlemail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Apr 2012 10:41:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Seiffert <kaffeemonster@googlemail.com>
Date: Mon, 30 Apr 2012 07:02:19 +0200

> Now the helper function from filter.c for negative offsets is exported,
> it can be used it in the jit to handle negative offsets.
> 
> First modify the asm load helper functions to handle:
> - know positive offsets
> - know negative offsets
> - any offset
> 
> then the compiler can be modified to explicitly use these helper
> when appropriate.
> 
> This fixes the case of a negative X register and allows to lift
> the restriction that bpf programs with negative offsets can't
> be jited.
> 
> Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Jan Seiffert <kaffeemonster@googlemail.com>

Applied, thanks.
