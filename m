Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0DUXTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:19:33 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:3551 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab0DUXTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:19:31 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.52,252,1270425600"; 
   d="scan'208";a="118762008"
From: Roland Dreier <rdreier@cisco.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sean.hefty@intel.com, amwang@redhat.com, opurdila@ixiacom.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com,
       davem@davemloft.net, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, rolandd@cisco.com
Subject: Re: [PATCH] Infiniband: Randomize local port allocation.
References: <20100412100744.5302.92442.sendpatchset@localhost.localdomain>
	<20100412100816.5302.74919.sendpatchset@localhost.localdomain>
	<201004130121.o3D1Lhh7099571@www262.sakura.ne.jp>
	<4BC41994.7030707@redhat.com> <4BC42FE0.4040601@redhat.com>
	<201004132207.GAJ52684.OJFtMQVFHOSFLO@I-love.SAKURA.ne.jp>
	<21DAC78125424ED291B5D6477CFF9657@amr.corp.intel.com>
	<201004140201.o3E21Aqn075978@www262.sakura.ne.jp>
	<195EB1AD388F455AA386EB214FCD09F4@amr.corp.intel.com>
	<201004150229.o3F2T4dZ054768@www262.sakura.ne.jp>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 21 Apr 2010 16:19:28 -0700
In-Reply-To: <201004150229.o3F2T4dZ054768@www262.sakura.ne.jp> (Tetsuo Handa's
	message of "Thu, 15 Apr 2010 11:29:04 +0900")
Message-ID: <adabpdco0lb.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied this part of the patch -- I preferred this one since the
goto into the middle of a loop seemed worse than a goto out of the loop...
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
