Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab0KIFy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:54:59 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59818 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0KIFy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:54:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2 17/23] kmsg_dumper: Introduce a new 'SOFT' dump reason
Cc: kosaki.motohiro@jp.fujitsu.com, Mike Waychison <mikew@google.com>,
        simon.kagstrom@netinsight.net, davem@davemloft.net,
        nhorman@tuxdriver.com, Matt Mackall <mpm@selenic.com>,
        adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, Americo Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
In-Reply-To: <20101109144749.BC6C.A69D9226@jp.fujitsu.com>
References: <20101108203316.22479.86025.stgit@crlf.mtv.corp.google.com> <20101109144749.BC6C.A69D9226@jp.fujitsu.com>
Message-Id: <20101109145540.BC72.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 14:54:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi
> 
> > It is a useful to be able to exercise kmsg_dumper implementations without
> > requiring a kernel oops or panic.  This commit adds a new reason called
> > KMSG_DUMP_SOFT, which signifies that the system isn't really going down.
> > 
> > This logic is used in a later commit that introduces the netoops driver.
> > 
> > Signed-off-by: Mike Waychison <mikew@google.com>
> > ---
> > 
> > It is also possible that we not introduce KMSG_DUMP_SOFT, and simply overload
> > the existing KMSG_DUMP_OOPS reason, but I figured that this would be cleaner.
> > 
> > TODO: Make sure mtdoops and ramoops do something useful with this flag?
> 
> Yes. If userland explicitly want to log, we have no reason to refuse it. :)

I meant I think your change has no problem.




> But, I don't think KMSG_DUMP_SOFT is good name because _SOFT don't explain
> anything.



