Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2FHPPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:15:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab2FHPPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:15:39 -0400
Date: Fri, 8 Jun 2012 17:15:32 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 7/8] x86/apic: Make cpu_mask_to_apicid() operations
 return error code
Message-ID: <20120608151531.GD4777@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
 <20120606082231.GD5991@gmail.com>
 <20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
 <1339107848.28766.104.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339107848.28766.104.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 03:24:05PM -0700, Suresh Siddha wrote:
> On Thu, 2012-06-07 at 15:15 +0200, Alexander Gordeev wrote:
> I am ok with these changes. But even better would be to remove the
> cpu_mask_to_apicid() and just use cpu_mask_to_apicid_and() instead.
> 
> Looks like there are only two places cpu_mask_to_apicid() being used
> anyways. So instead of patches 7 and 8, can you remove
> cpu_mask_to_apicid() in patch-7 and fixup the return value of
> cpu_mask_to_apicid_and() in patch-8

oops, I was not fast enough - Ingo has pulled 7 and 8
I will post the update on top of that

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
