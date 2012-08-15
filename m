Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2HOWPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:15:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52513 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2HOWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:15:52 -0400
Date: Wed, 15 Aug 2012 15:15:49 -0700 (PDT)
Message-Id: <20120815.151549.1835466517645273818.davem@davemloft.net>
To: jiri@resnulli.us
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
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120815074612.GB1726@minipsycho.orion>
References: <1344956748-2099-2-git-send-email-jiri@resnulli.us>
	<1344983624.2690.77.camel@bwh-desktop.uk.solarflarecom.com>
	<20120815074612.GB1726@minipsycho.orion>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Wed, 15 Aug 2012 09:46:12 +0200

> You are probably right. I'm not sure how to handle this correctly
> though. Adding some hard limit number might not be correct.

I would just use a hard limit of something like 8 for now, and if we
need to expand this limit we can consider how to do so with real known
usage in mind rather than pure speculation.
