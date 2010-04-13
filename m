Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0DMQc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:32:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:33223 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab0DMQcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:32:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,198,1270450800"; 
   d="scan'208";a="265157689"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Tetsuo Handa'" <penguin-kernel@I-love.SAKURA.ne.jp>, <amwang@redhat.com>,
       <rolandd@cisco.com>
Cc: <opurdila@ixiacom.com>, <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>,
       <nhorman@tuxdriver.com>, <davem@davemloft.net>, <ebiederm@xmission.com>,
       <linux-kernel@vger.kernel.org>
References: <20100412100744.5302.92442.sendpatchset@localhost.localdomain>	<20100412100816.5302.74919.sendpatchset@localhost.localdomain>	<201004130121.o3D1Lhh7099571@www262.sakura.ne.jp>	<4BC41994.7030707@redhat.com>	<4BC42FE0.4040601@redhat.com> <201004132207.GAJ52684.OJFtMQVFHOSFLO@I-love.SAKURA.ne.jp>
Subject: RE: [Patch 3/3] net: reserve ports for applications using fixed port numbers
Date: Tue, 13 Apr 2010 09:32:22 -0700
Message-ID: <21DAC78125424ED291B5D6477CFF9657@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcrbCkI/ai0piY/8RCejW5vd1CL7OgAG2xmw
In-Reply-To: <201004132207.GAJ52684.OJFtMQVFHOSFLO@I-love.SAKURA.ne.jp>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Sean and Roland, is below patch correct?
>inet_is_reserved_local_port() is the new function proposed in this patchset.

It looks correct to me.  I didn't test the patch series, but if I comment out
the call to inet_is_reserved_local_port() in the provided below, the changes
worked fine for me.

Acked-by: Sean Hefty <sean.hefty@intel.com>

