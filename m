Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab1EPE23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 00:28:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56906 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1EPE21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 00:28:27 -0400
X-Nat-Received: from [202.181.97.72]:61326 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1305520062.24284
Message-Id: <201105160427.p4G4Rfbq041525@www262.sakura.ne.jp>
Subject: Re: [Bug #34492] [2.6.39-rc4, x86_32] Stall at default_idle()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: rjw@sisk.pl
Cc: kernel-testers@vger.kernel.org, maciej.rutecki@gmail.com,
        florian@mickler.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 16 May 2011 13:27:41 +0900
References: <So1vU2GC7XM.A.5wB.44vzNB@chimera> <HA8urZ3ZRcP.A.6QC.Q5vzNB@chimera>
In-Reply-To: <HA8urZ3ZRcP.A.6QC.Q5vzNB@chimera>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 16052011 #5417128, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.38.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34492
> Subject		: [2.6.39-rc4, x86_32] Stall at default_idle()
> Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Date		: 2011-04-27 4:49 (18 days old)
> Message-ID	: <201104270449.p3R4n54n023453@www262.sakura.ne.jp>
> References	: http://marc.info/?l=linux-kernel&m=130387977425687&w=2
> 
I don't know whether this bug has been fixed or not, for I haven't succeeded
to reproduce this bug since then. Can somebody figure out what was happening?
