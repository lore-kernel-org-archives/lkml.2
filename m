Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2HPFtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:49:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64143 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab2HPFtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:49:06 -0400
Date: Thu, 16 Aug 2012 07:48:59 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, netdev@vger.kernel.org, edumazet@google.com,
        faisal.latif@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, fubar@us.ibm.com, andy@greyhouse.net,
        divy@chelsio.com, jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, therbert@google.com, xiyou.wangcong@gmail.com,
        joe@perches.com, gregory.v.rose@intel.com, john.r.fastabend@intel.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, bridge@lists.linux-foundation.org,
        fbl@redhat.com
Subject: Re: [patch net-next v2 01/15] net: introduce upper device lists
Message-ID: <20120816054859.GA1769@minipsycho.orion>
References: <1344956748-2099-2-git-send-email-jiri@resnulli.us>
 <1344983624.2690.77.camel@bwh-desktop.uk.solarflarecom.com>
 <20120815074612.GB1726@minipsycho.orion>
 <20120815.151549.1835466517645273818.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815.151549.1835466517645273818.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thu, Aug 16, 2012 at 12:15:49AM CEST, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Wed, 15 Aug 2012 09:46:12 +0200
>
>> You are probably right. I'm not sure how to handle this correctly
>> though. Adding some hard limit number might not be correct.
>
>I would just use a hard limit of something like 8 for now, and if we
>need to expand this limit we can consider how to do so with real known
>usage in mind rather than pure speculation.

Okay. I will repost the set soon.
