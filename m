Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0HXDxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 23:53:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49047
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab0HXDxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 23:53:02 -0400
Date: Mon, 23 Aug 2010 20:53:19 -0700 (PDT)
Message-Id: <20100823.205319.146374452.davem@davemloft.net>
To: sanagi.koki@jp.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        laijs@cn.fujitsu.com, scott.a.mcmillan@intel.com, rostedt@goodmis.org,
        eric.dumazet@gmail.com, fweisbec@gmail.com,
        mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH v4 5/5] perf:add a script shows a process of packet
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C72439D.3040001@jp.fujitsu.com>
References: <4C72422C.5070102@jp.fujitsu.com>
	<4C72439D.3040001@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Date: Mon, 23 Aug 2010 18:47:09 +0900

> Add a perf script which shows a process of packets and processed time.
> It helps us to investigate networking or network device.
 ...
> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
