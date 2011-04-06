Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1DFTxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:53:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42874
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab1DFTxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:53:33 -0400
Date: Wed, 06 Apr 2011 12:52:56 -0700 (PDT)
Message-Id: <20110406.125256.102558618.davem@davemloft.net>
To: lucian.grijincu@gmail.com
Cc: adobriyan@gmail.com, ebiederm@xmission.com, tavi@cs.pub.ro,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/24] sysctl: net: call unregister_net_sysctl_table
 where needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <05ae3c2fdd2db1f6a2fd3cd900164667e615f4f8.1301711868.git.lucian.grijincu@gmail.com>
References: <cover.1301711868.git.lucian.grijincu@gmail.com>
	<cover.1301711868.git.lucian.grijincu@gmail.com>
	<05ae3c2fdd2db1f6a2fd3cd900164667e615f4f8.1301711868.git.lucian.grijincu@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Sat,  2 Apr 2011 04:53:15 +0200

> ctl_table_headers registered with register_net_sysctl_table should
> have been unregistered with the equivalent unregister_net_sysctl_table
> 
> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>

Oops, hmmm...  Can this actually cause any real problems currently?

If so I'd like to toss this specific patch into net-2.6

Thanks.
