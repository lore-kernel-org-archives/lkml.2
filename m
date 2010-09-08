Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab0IHFxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:53:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46577
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab0IHFxJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:53:09 -0400
Date: Tue, 07 Sep 2010 22:53:27 -0700 (PDT)
Message-Id: <20100907.225327.229757822.davem@davemloft.net>
To: bookjovi@gmail.com
Cc: eric.dumazet@gmail.com, johannes.berg@intel.com, ebiederm@xmission.com,
        adobriyan@openvz.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: Fix kfree NULL pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTim+=vj+k3=1hzT3=J4ssOopp5Eq=g+DHis=pZFN@mail.gmail.com>
References: <AANLkTikp0m8cQYfEBHP_E8XpGZqdMj6Cr4M=aWCnei=X@mail.gmail.com>
	<1283923185.2634.772.camel@edumazet-laptop>
	<AANLkTim+=vj+k3=1hzT3=J4ssOopp5Eq=g+DHis=pZFN@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jovi zhang <bookjovi@gmail.com>
Date: Wed, 8 Sep 2010 13:33:28 +0800

>  Also I check kfree usage in other code, I havn't find any kfree(NULL) usage.

You aren't looking hard enough.

Please leave this code alone, it's functionally correct and fine.
