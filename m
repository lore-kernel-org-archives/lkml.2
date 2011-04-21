Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1DUFpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:45:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51034 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1DUFpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:45:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] x86, numa: Revert "Fix fakenuma boot failure"
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        x86@kernel.org
In-Reply-To: <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com> <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com>
Message-Id: <20110421144621.7338.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 21 Apr 2011 14:45:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 7d6b46707f24 (x86, NUMA: Fix fakenuma boot failure) could cause physical 
> NUMA topologies to move sibling cpus to a single node when in reality 
> they are in separate domains.  This may result in some nodes being 
> completely void of cpus, which doesn't accurately represent the correct 
> topology.
> 
> This commit was intended as a fix for NUMA emulation, but should not 
> cause a regression for real NUMA machines as a side effect.
> 
> Reported-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



