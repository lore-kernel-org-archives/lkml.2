Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0GGWZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:25:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55054
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756653Ab0GGWZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:25:32 -0400
Date: Wed, 07 Jul 2010 15:25:45 -0700 (PDT)
Message-Id: <20100707.152545.22034265.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com, stolarchuk@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net: vmxnet3 fixes [0/5] Spare skb to avoid
 starvation
From: David Miller <davem@davemloft.net>
In-Reply-To: <89E2752CFA8EC044846EB8499819134102BD8D444B@EXCH-MBX-4.vmware.com>
References: <alpine.LRH.2.00.1007070125440.4652@localhost.localdomain>
	<20100707.144048.25140070.davem@davemloft.net>
	<89E2752CFA8EC044846EB8499819134102BD8D444B@EXCH-MBX-4.vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Wed, 7 Jul 2010 15:19:08 -0700

> The version numbers bumps although seemingly pointless (and
> harmless), make my life easy to track and maintain the bug#-to-fix
> mapping.

But in an upstream context, they make no sense at all.

Anyone running upstream, is going to run at the last version bump you
make in the driver, so what users report to you as the driver version
will be correct.

Please fix this.
