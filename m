Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0GGVoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:44:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52080
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757607Ab0GGVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:34 -0400
Date: Wed, 07 Jul 2010 14:40:48 -0700 (PDT)
Message-Id: <20100707.144048.25140070.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com, stolarchuk@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net: vmxnet3 fixes [0/5] Spare skb to avoid
 starvation
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007070125440.4652@localhost.localdomain>
References: <alpine.LRH.2.00.1007070125440.4652@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A couple problems remaining in this patch set:

1) Too many bug fixes for this late in the -rc series of 2.6.35
   Pick a smaller number of fixes, the most critical ones, perhaps
   2 or 3, and re-submit those for net-2.6

   Pick the ones that produce easily triggers crashes or documented
   regressions present on the official lkml regression list.

   Send the rest in for net-next-2.6

2) Bumping the driver version every patch in a patch series is pointless.
   Do the bump once, at the end of the series.

Thanks.
