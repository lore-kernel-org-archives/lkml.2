Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0EJMpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:45:15 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:57398
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750721Ab0EJMpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:45:12 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432P98dN936eM1447R62a3Lzz1202hzz6d525hz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L27FD4-02-0GT-02
X-M-MSG: 
Date: Mon, 10 May 2010 14:43:53 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>
Subject: Re: [patch 1/4] x86,perf: P4 PMU -- configurate predefined events
Message-ID: <20100510124353.GG6450@erda.amd.com>
References: <20100508112550.187421916@openvz.org>
 <20100508112716.741423821@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100508112716.741423821@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.10 07:25:51, Cyrill Gorcunov wrote:
> If an event is not RAW we should exit p4_hw_config
> early but call x86_setup_perfctr as well.
> 
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Robert Richter <robert.richter@amd.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Robert, if only I'm not missing something this is
> a side effect of commit 9d0fcba67e47ff398a6fa86476d4884d472dc98a,
> wonders why don't we hit it earlier. Am I wrong?

Yes, that's true, the function had have two exit points. Thanks for
the fix.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

