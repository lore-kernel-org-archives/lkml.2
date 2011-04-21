Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1DUFps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:45:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51033 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1DUFpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:45:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: Linux 2.6.39-rc4 (regression: NUMA on multi-node CPUs broken)
Cc: kosaki.motohiro@jp.fujitsu.com,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104201916490.12634@chino.kir.corp.google.com>
References: <20110421110452.7322.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104201916490.12634@chino.kir.corp.google.com>
Message-Id: <20110421144620.7337.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 21 Apr 2011 14:45:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 21 Apr 2011, KOSAKI Motohiro wrote:
> 
> > Simple revert 7d6b46707f24 makes the same boot failure again.
> > 
> 
> Do you have CONFIG_DEBUG_PER_CPU_MAPS enabled?  If not, please send your 
> .config.

Oops. Yes, I have CONFIG_DEBUG_PER_CPU_MAPS=y.



