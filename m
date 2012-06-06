Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2FFIms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:42:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983Ab2FFImp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:42:45 -0400
Date: Wed, 6 Jun 2012 10:42:38 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 4/8] x86: apic: Factor out default
 vector_allocation_domain() operations
Message-ID: <20120606084237.GA11493@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
 <20120606082231.GD5991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606082231.GD5991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:22:31AM +0200, Ingo Molnar wrote:
> This one didn't apply due to the following fresh patch in -tip:
> 
> 0b8255e660a0 x86/x2apic/cluster: Use all the members of one cluster specified in the smp_affinity 
> 
> So I applied the first three to tip:x86/apic, mind sending the 
> remaining 4 patches on top of -tip?

Sure.
5/8 should apply now, too.
And sorry for the absent In-Reply-To.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
