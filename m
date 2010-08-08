Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab0HHFtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 01:49:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57806
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab0HHFtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 01:49:50 -0400
Date: Sat, 07 Aug 2010 22:50:09 -0700 (PDT)
Message-Id: <20100807.225009.43057146.davem@davemloft.net>
To: grant.likely@secretlab.ca
CC: linux-kernel@vger.kernel.org
Subject: OF change bustage...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Niagara2 crypto driver started failing to build recently.

Known issue Grant? :-)

drivers/crypto/n2_core.c: In function 'find_devino_index':
drivers/crypto/n2_core.c:1583:21: error: 'struct platform_device' has no member named 'num_irqs'
drivers/crypto/n2_core.c: In function 'spu_map_ino':
drivers/crypto/n2_core.c:1606:14: error: 'struct platform_device' has no member named 'irqs'

Looks simply like missing "archdata." prefixes.
