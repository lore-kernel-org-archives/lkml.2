Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0HXDwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 23:52:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49018
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab0HXDwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 23:52:34 -0400
Date: Mon, 23 Aug 2010 20:52:50 -0700 (PDT)
Message-Id: <20100823.205250.67893208.davem@davemloft.net>
To: sanagi.koki@jp.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        laijs@cn.fujitsu.com, scott.a.mcmillan@intel.com, rostedt@goodmis.org,
        eric.dumazet@gmail.com, fweisbec@gmail.com,
        mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH v4 2/5] napi: convert trace_napi_poll to TRACE_EVENT
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C7242D7.4050009@jp.fujitsu.com>
References: <4C72422C.5070102@jp.fujitsu.com>
	<4C7242D7.4050009@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Date: Mon, 23 Aug 2010 18:43:51 +0900

> From: Neil Horman <nhorman@tuxdriver.com>
> 
> This patch converts trace_napi_poll from DECLARE_EVENT to TRACE_EVENT to improve
> the usability of napi_poll tracepoint.
> 
>           <idle>-0     [001] 241302.750777: napi_poll: napi poll on napi struct f6acc480 for device eth3
>           <idle>-0     [000] 241302.852389: napi_poll: napi poll on napi struct f5d0d70c for device eth1
> 
> An original patch is below.
> http://marc.info/?l=linux-kernel&m=126021713809450&w=2
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> And add a fix by Steven Rostedt.
> http://marc.info/?l=linux-kernel&m=126150506519173&w=2
> 
> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
