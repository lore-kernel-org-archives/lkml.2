Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1DQNF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:05:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1DQNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aukoWK1GMr8INbC8Epwwu8DE3iwYNtx4HUPrmLRKspBcauyhL3ahY4m5U0feZnt3eE
         yXjzCaPr+yaylFrQwc6ec/tUXHNX/jGIKWl+9rmfJ2mhu/2k/i+emerYJv0DhDthlCKV
         CUWDd0RbsNE43Z1CnLcGx9DG4Yk/Rwa8k4jT0=
Message-ID: <4DAAE5AA.1090302@gmail.com>
Date: Sun, 17 Apr 2011 17:05:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Shaun Ruffell <sruffell@digium.com>
Subject: Re: [Bug #33252] [regression 2.6.39-rc2][bisected] "perf, x86: P4
 PMU - Read proper MSR register to catch" and NMIs
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.WiB.dGuqNB@chimera>
In-Reply-To: <_H4l51C1wXN.A.WiB.dGuqNB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2011 04:57 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.38.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33252
> Subject		: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper MSR register to catch" and NMIs
> Submitter	: Shaun Ruffell <sruffell@digium.com>
> Date		: 2011-04-06 22:30 (12 days old)
> First-Bad-Commit: http://git.kernel.org/linus/242214f9c1eeaae40eca11e3b4d37bfce960a7cd
> Message-ID	: <20110406223036.GA15721@digium.com>
> References	: http://marc.info/?l=linux-kernel&m=130212907032580&w=2
> Handled-By	: Don Zickus <dzickus@redhat.com>
> Patch		: http://cache.gmane.org//gmane/linux/kernel/1125621-001.bin
> 
> 

We're working on it, patch is almost done. I guess it'll be published next week.

-- 
    Cyrill
