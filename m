Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0ICCR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:17:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54493
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764Ab0ICCRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:17:25 -0400
Date: Thu, 02 Sep 2010 19:17:41 -0700 (PDT)
Message-Id: <20100902.191741.233696520.davem@davemloft.net>
To: sanagi.koki@jp.fujitsu.com
Cc: rostedt@goodmis.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        laijs@cn.fujitsu.com, scott.a.mcmillan@intel.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com,
        mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH v4 0/5] netdev: show a process of packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C80592B.2060406@jp.fujitsu.com>
References: <4C72422C.5070102@jp.fujitsu.com>
	<1283212210.3656.84.camel@gandalf.stny.rr.com>
	<4C80592B.2060406@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Date: Fri, 03 Sep 2010 11:10:51 +0900

> Thanks many acks. and I have one question.
> 
> These patches have several component.
> 
> Patch1 is kernel component, but patch2-5 are netdev component.
> What tree is good to be included ?
> If it is not net-next, I must rebase to another tree.

I would prefer it goes into the tracing tree or whatever is the most appropriate
for patch #1.
