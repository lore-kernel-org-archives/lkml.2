Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1JLXNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 19:13:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:32943 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1JLXNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 19:13:18 -0400
Date: Wed, 12 Oct 2011 19:10:15 -0400 (EDT)
Message-Id: <20111012.191015.389657713979036834.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: muralira@google.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] net-netlink: Add a new attribute to expose TOS
 values via netlink
From: David Miller <davem@davemloft.net>
In-Reply-To: <1318446934.2644.0.camel@edumazet-laptop>
References: <20111012085235.3b78729b@nehalam.linuxnetplumber.net>
	<1318446035-10267-1-git-send-email-muralira@google.com>
	<1318446934.2644.0.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 12 Oct 2011 16:10:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 12 Oct 2011 21:15:34 +0200

> Le mercredi 12 octobre 2011 à 12:00 -0700, Muraliraja Muniraju a écrit :
>> From: Murali Raja <muralira@google.com>
>> 
>> This patch exposes the tos value for the TCP sockets when the TOS flag
>> is requested in the ext_flags for the inet_diag request. This would mainly be
>> used to expose TOS values for both for TCP and UDP sockets. Currently it is
>> supported for TCP. When netlink support for UDP would be added the support
>> to expose the TOS values would alse be done. For IPV4 tos value is exposed
>> and for IPV6 tclass value is exposed.
>> 
>> Signed-off-by: Murali Raja <muralira@google.com>
>> ---
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone.
