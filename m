Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0KMWpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:45:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:53888 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0KMWpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:45:19 -0500
Subject: Re: [tg_shares_up rewrite v3 09/11] sched: demand based
 update_cfs_load()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTintRZjoYcGvadw7CVudFxF5bzhFYbCK_VkRfpZp@mail.gmail.com>
References: <20101112032405.657789056@google.com>
	 <20101112032702.028843817@google.com> <1289559198.2084.214.camel@laptop>
	 <AANLkTi=vUs7f3bYE-0OM7fARzbNTbGEU4bDd1pcDoOq-@mail.gmail.com>
	 <AANLkTintRZjoYcGvadw7CVudFxF5bzhFYbCK_VkRfpZp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 23:45:06 +0100
Message-ID: <1289688306.2109.387.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 18:42 -0800, Paul Turner wrote:
> 
> Let me know if you still think this warrants any changes and I'll (fix
> accordingly) and repost with the "-p0" stripping fixed.
> 
Nah, its fine I just thought the code odd, but it does make sense.

Please repost the patches as -p1
