Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab0GNUoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:44:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41024
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757333Ab0GNUoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:44:00 -0400
Date: Wed, 14 Jul 2010 13:44:15 -0700 (PDT)
Message-Id: <20100714.134415.183043981.davem@davemloft.net>
To: siccegge@cs.fau.de
Cc: nico@fluxnic.net, tony@atomide.com, dwalker@codeaurora.org,
        rubini@unipv.it, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 11/11] Removing dead REDWOOD_{5,6}
From: David Miller <davem@davemloft.net>
In-Reply-To: <adba61f63f4439ac17f2e428429f01ae5e65ab15.1279110895.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
	<adba61f63f4439ac17f2e428429f01ae5e65ab15.1279110895.git.siccegge@cs.fau.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 14 Jul 2010 14:41:31 +0200

> REDWOOD_{5,6} doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Again, if you're going to kill this off you should also delete the
references in drivers/net/Kconfig at the same time.

Please fix this up and resubmit your patch, thanks.
