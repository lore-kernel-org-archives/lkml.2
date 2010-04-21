Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0DUXUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:20:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33825
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab0DUXUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:20:19 -0400
Date: Wed, 21 Apr 2010 16:20:24 -0700 (PDT)
Message-Id: <20100421.162024.248644052.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Subject: Re: [PATCH net-next-2.6 v3] fasync: RCU and fine grained locking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271274935.16881.1746.camel@edumazet-laptop>
References: <1271257027.16881.1663.camel@edumazet-laptop>
	<1271259264.16881.1703.camel@edumazet-laptop>
	<1271274935.16881.1746.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 14 Apr 2010 21:55:35 +0200

> [PATCH net-next-2.6 v3] fasync: RCU and fine grained locking

BTW, just to be clear I made sure to apply V3 of this
patch not the initial submission :-)
