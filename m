Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1DEFXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 01:23:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52274 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1DEFXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 01:23:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: mmotm 2011-03-31-14-48 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1301949991.2221.5.camel@twins>
References: <20110403181147.AE42.A69D9226@jp.fujitsu.com> <1301949991.2221.5.camel@twins>
Message-Id: <20110405142357.432E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue,  5 Apr 2011 14:23:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 2011-04-03 at 18:11 +0900, KOSAKI Motohiro wrote:
> > Ingo, Perter, Is this known issue?
> > 
> > 
> > =======================================================================
> > [    0.169037] divide error: 0000 [#1] SMP
> > [    0.169982] last sysfs file:
> > [    0.169982] CPU 0
> > [    0.169982] Modules linked in:
> > [    0.169982]
> > [    0.169982] Pid: 1, comm: swapper Not tainted 2.6.39-rc1-mm1+ #2 FUJITSU-SV      PRIMERGY                      /D2559-A1
> > [    0.169982] RIP: 0010:[<ffffffff8104ad4c>]  [<ffffffff8104ad4c>] find_busiest_group+0x38c/0xd30 
> 
> Not something I've recently seen, so no.

OK, I'll digg it later.

Thanks.




