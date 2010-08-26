Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924Ab0HZECe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:02:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46590 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0HZECc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:02:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] tcp: select(writefds) don't hang up when a peer close connection
Cc: kosaki.motohiro@jp.fujitsu.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
        bhutchings@solarflare.com
In-Reply-To: <20100825.205154.191390581.davem@davemloft.net>
References: <AANLkTinPhzMSQ01AXZmDQw8h4OnuS8yoQu7eKog637LL@mail.gmail.com> <20100825.205154.191390581.davem@davemloft.net>
Message-Id: <20100826130200.F66A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 26 Aug 2010 13:02:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Thu, 26 Aug 2010 12:09:55 +0900
> 
> > Probably my example is not so good. That's not my point.
> > In the example application, client and server socket is in the same process.
> > But it's NOT generic. usually, client and server are another process. then,
> > client can't expect when server close socket.
> > 
> > The most big matter is, this is can't be avoided in userland. In addition,
> > EVERY application don't want application hang up. we don't hesitate
> > userland change.
> 
> Ok, you and Ben Hutchings have convinced me to reconsider.
> 
> And this matches what even BSD4.4-Lite does (I checked yesterday before
> my initial reply), so I will apply this patch.
> 
> Thanks for your patience.

Great!

Thank you!!



