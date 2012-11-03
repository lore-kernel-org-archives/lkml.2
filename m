Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314Ab2KCB6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 21:58:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49496 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab2KCB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 21:58:41 -0400
Date: Fri, 02 Nov 2012 21:58:40 -0400 (EDT)
Message-Id: <20121102.215840.116110325989713705.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sbhatewara@vmware.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jongman.heo@samsung.com
Subject: Re: [PATCH] vmxnet3: must split too big fragments
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351531849.12280.54.camel@edumazet-glaptop>
References: <1351000246.8609.1926.camel@edumazet-glaptop>
	<1351021160.8609.2503.camel@edumazet-glaptop>
	<1351531849.12280.54.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 29 Oct 2012 18:30:49 +0100

> From: Eric Dumazet <edumazet@google.com>
> 
> vmxnet3 has a 16Kbytes limit per tx descriptor, that happened to work
> as long as we provided PAGE_SIZE fragments.
> 
> Our stack can now build larger fragments, so we need to split them to
> the 16kbytes boundary.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: jongman heo <jongman.heo@samsung.com>
> Tested-by: jongman heo <jongman.heo@samsung.com>
> Cc: Shreyas Bhatewara <sbhatewara@vmware.com>

Applied, thanks everyone.
