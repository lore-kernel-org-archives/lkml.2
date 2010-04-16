Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0DPCSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 22:18:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab0DPCSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 22:18:39 -0400
Message-ID: <4BC7C9CF.20403@redhat.com>
Date: Fri, 16 Apr 2010 10:22:07 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Sean Hefty <sean.hefty@intel.com>
CC: "'Tetsuo Handa'" <penguin-kernel@I-love.SAKURA.ne.jp>,
       opurdila@ixiacom.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, davem@davemloft.net, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, rolandd@cisco.com,
       linux-rdma@vger.kernel.org
Subject: Re: [PATCH] rdma/cm: Randomize local port allocation.
References: <20100412100744.5302.92442.sendpatchset@localhost.localdomain>	<20100412100816.5302.74919.sendpatchset@localhost.localdomain>	<201004130121.o3D1Lhh7099571@www262.sakura.ne.jp>	<4BC41994.7030707@redhat.com>	<4BC42FE0.4040601@redhat.com> <201004132207.GAJ52684.OJFtMQVFHOSFLO@I-love.SAKURA.ne.jp> <21DAC78125424ED291B5D6477CFF9657@amr.corp.intel.com> <201004140201.o3E21Aqn075978@www262.sakura.ne.jp> <195EB1AD388F455AA386EB214FCD09F4@amr.corp.intel.com> <201004150229.o3F2T4dZ054768@www262.sakura.ne.jp> <5CE6BC7B954643FAAFFD2AD66F673CBD@amr.corp.intel.com>
In-Reply-To: <5CE6BC7B954643FAAFFD2AD66F673CBD@amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Hefty wrote:
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
>> Randomize local port allocation in a way sctp_get_port_local() does.
>> Update rover at the end of loop since we're likely to pick a valid port
>> on the first try.
>>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reviewed-by: Sean Hefty <sean.hefty@intel.com>
> 

Thanks, everyone!

> 
> I like this version, thanks!  I'm not sure which tree to merge it through.
> Are you needing this for 2.6.34, or is 2.6.35 okay?
> 

As soon as possible, so 2.6.34. :)
