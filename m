Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0KNFHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:07:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44829 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0KNFHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:07:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bruno Randolf <br1@einfach.org>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average (EWMA) function
Cc: kosaki.motohiro@jp.fujitsu.com, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
        peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kevin.granade@gmail.com, "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201011121044.40274.br1@einfach.org>
References: <4CDC333E.4070104@s5r6.in-berlin.de> <201011121044.40274.br1@einfach.org>
Message-Id: <20101114133029.E008.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:07:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Why do ewma_init() and ewma_add() return their first argument?  They look
> > to me like they can be straight-forward void functions.
> 
> You are right, for ewma_init() it does not make sense.
> 
> For ewma_add() I think it does. This has been discussed before (e.g. 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-10/msg09124.html).
> Some people might want to get the value when they add a sample by using 
> ewma_get(ewma_add(&ewma, val));

	ewma_add(&ewma, val);
	ewma_get(&ewma);

is enough simpler and cleaner. I don't oppse this :)


