Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0DPNy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 09:54:29 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63434 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757648Ab0DPNy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 09:54:27 -0400
To: amwang@redhat.com, sean.hefty@intel.com
Cc: opurdila@ixiacom.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, davem@davemloft.net, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, rolandd@cisco.com,
       linux-rdma@vger.kernel.org
Subject: Re: [PATCH] rdma/cm: Randomize local port allocation.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201004140201.o3E21Aqn075978@www262.sakura.ne.jp>
	<195EB1AD388F455AA386EB214FCD09F4@amr.corp.intel.com>
	<201004150229.o3F2T4dZ054768@www262.sakura.ne.jp>
	<5CE6BC7B954643FAAFFD2AD66F673CBD@amr.corp.intel.com>
	<4BC7C9CF.20403@redhat.com>
In-Reply-To: <4BC7C9CF.20403@redhat.com>
Message-Id: <201004162254.FJF73478.SHOOMOFtQFVJLF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 16 Apr 2010 22:54:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang wrote:
> Sean Hefty wrote:
> > I like this version, thanks!  I'm not sure which tree to merge it through.
> > Are you needing this for 2.6.34, or is 2.6.35 okay?
> > 
> 
> As soon as possible, so 2.6.34. :)
> 
Cong, merge window for 2.6.34 was already closed.
You need to make your patchset towards 2.6.35 (using net-next-2.6 tree)
rather than 2.6.34 (using linux-2.6 tree). Therefore, this patch being
queued for 2.6.35 (through net-next-2.6 tree) should be okay for you.
