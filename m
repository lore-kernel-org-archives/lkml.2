Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2EUHLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab2EUHLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:11:47 -0400
Date: Mon, 21 May 2012 09:11:36 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521071135.GA28930@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120518144153.GD8455@moon>
 <20120518154236.GA23406@dhcp-26-207.brq.redhat.com>
 <20120518155119.GG8455@moon>
 <20120519104725.GA18768@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120519104725.GA18768@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 02:47:25PM +0400, Cyrill Gorcunov wrote:
> On Fri, May 18, 2012 at 07:51:19PM +0400, Cyrill Gorcunov wrote:

> > Ah, you mean io-apic here. I'll try to find some time tonight/tomorrow-morning
> > for review. Thanks!
> 
> Sorry for delay, Alexander. I can only review the code (I've no x2apic
> testing machine at the moment) and it looks good for me.
> 
> Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thank you, Cyrill.

> p.s. Hope Suresh and Yinghai will take a look too. The thing which bothers
> me is that we use LowPrio delivery mode, while there is no lowprio in
> x2apic ipi messages and I assume the same should apply to ioapic generated
> messages.

My understanding of the specification is LowestPrio is not supported only for
IPIs on x2APIC. Can not imagine why IO-APICs need to be limited here. But let's
hear what the guys think.


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
