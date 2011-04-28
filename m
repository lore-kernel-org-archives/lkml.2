Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1D1Uqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:46:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45458
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685Ab1D1Uqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:46:36 -0400
Date: Thu, 28 Apr 2011 13:46:03 -0700 (PDT)
Message-Id: <20110428.134603.15230365.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: mirq-linux@rere.qmqm.pl, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, santil@linux.vnet.ibm.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: ibmveth runtime errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110428121124.39c036ff.sfr@canb.auug.org.au>
References: <20110427144901.4c3f79b3.sfr@canb.auug.org.au>
	<20110427103622.GA22781@rere.qmqm.pl>
	<20110428121124.39c036ff.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 28 Apr 2011 12:11:24 +1000

> From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
> Date: Thu, 28 Apr 2011 11:59:15 +1000
> Subject: [PATCH] net: ibmveth: force reconfiguring checksum settings on
>  startup
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Commit b9367bf3ee6d ("net: ibmveth: convert to hw_features") accidentally
> removed call to ibmveth_set_csum_offload() in ibmveth_probe(). Put the
> call back where it was, but with additional error checking provided
> by ibmveth_set_features().
> 
> Signed-off-by: Micha©© Miros©©aw <mirq-linux@rere.qmqm.pl>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> [sfr: dev -> netdev]
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks everyone.
