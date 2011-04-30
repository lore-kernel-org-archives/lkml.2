Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab1D3Drt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 23:47:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43406
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221Ab1D3Drs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 23:47:48 -0400
Date: Fri, 29 Apr 2011 20:47:14 -0700 (PDT)
Message-Id: <20110429.204714.193727944.davem@davemloft.net>
To: jgmyers@proofpoint.com
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: fix incorrect unregistration of sysctl when last
 ip deleted
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DBB3480.9020708@proofpoint.com>
References: <201104272312.p3RNCcl6002068@jgmyers-vm1.eng.proofpoint.com>
	<20110429.134524.116375005.davem@davemloft.net>
	<4DBB3480.9020708@proofpoint.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Gardiner Myers <jgmyers@proofpoint.com>
Date: Fri, 29 Apr 2011 14:58:24 -0700

> The "how" parameter indicates the device is being deleted. In this
> case, the device is not being deleted.

It means that ipv6 is being disabled on the device.

Which is what happens when one of the following happens:

1) the MTU is too small to support ipv6 properly

2) no configured ipv6 addresses remain on the device

3) the device is being unregistered
