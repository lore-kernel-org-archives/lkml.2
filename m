Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab1D2OLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:11:49 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:30664
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757916Ab1D2OLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:11:47 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKF3EY-01-5UZ-02
X-M-MSG: 
Date: Fri, 29 Apr 2011 16:11:16 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 22/23] sched: Move sched domain storage into the topology
 list
Message-ID: <20110429141116.GE22001@alberich.amd.com>
References: <20110407120941.400629539@chello.nl>
 <20110407122942.924926412@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110407122942.924926412@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 08:10:03AM -0400, Peter Zijlstra wrote:
> In order to remove the last dependency on the statid domain levels,

typo:

s/statid/static/


Andreas


