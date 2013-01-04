Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3ADVdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:33:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40978 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3ADVdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:33:33 -0500
Date: Fri, 04 Jan 2013 13:33:31 -0800 (PST)
Message-Id: <20130104.133331.1729083969241157711.davem@davemloft.net>
To: jiri@resnulli.us
Cc: netdev@vger.kernel.org, edumazet@google.com, faisal.latif@intel.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        fubar@us.ibm.com, andy@greyhouse.net, divy@chelsio.com,
        jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, bhutchings@solarflare.com, therbert@google.com,
        xiyou.wangcong@gmail.com, joe@perches.com, gregory.v.rose@intel.com,
        john.r.fastabend@intel.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        bridge@lists.linux-foundation.org, fbl@redhat.com
Subject: Re: [patch net-next V6 00/15] net: introduce upper device lists
 and remove dev->master
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357289343-817-1-git-send-email-jiri@resnulli.us>
References: <1357289343-817-1-git-send-email-jiri@resnulli.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri,  4 Jan 2013 09:48:48 +0100

> This patchset adds a possibility to record upper device linkage.
> All upper<->lower devices are converted to use this mechanism right after.
> That leads to dev->master removal because this info becomes redundant since
> "master links" have the same value.

Series applied, thanks Jiri.
