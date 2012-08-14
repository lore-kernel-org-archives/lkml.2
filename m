Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2HNJC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:02:59 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59575 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab2HNJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:02:56 -0400
Message-ID: <502A1429.9060005@gmail.com>
Date: Tue, 14 Aug 2012 17:02:33 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jiri Pirko <jiri@resnulli.us>
CC: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        faisal.latif@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, fubar@us.ibm.com, andy@greyhouse.net,
        divy@chelsio.com, jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, bhutchings@solarflare.com, therbert@google.com,
        joe@perches.com, gregory.v.rose@intel.com, john.r.fastabend@intel.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, bridge@lists.linux-foundation.org,
        fbl@redhat.com
Subject: Re: [patch net-next 01/16] net: introduce upper device lists
References: <1344871635-1052-1-git-send-email-jiri@resnulli.us> <1344871635-1052-2-git-send-email-jiri@resnulli.us>
In-Reply-To: <1344871635-1052-2-git-send-email-jiri@resnulli.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 11:27 PM, Jiri Pirko wrote:
> This lists are supposed to serve for storing pointers to all upper devices.
> Eventually it will replace dev->master pointer which is used for
> bonding, bridge, team but it cannot be used for vlan, macvlan where
> there might be multiple "masters" present.
>
> New upper device list resolves this limitation. Also, the information
> stored in lists is used for preventing looping setups like
> "bond->somethingelse->samebond"

Hi, Jiri,

I have some difficulty to understand this patch description, so take 
bridged bonding as an example, IIUC, both the bridge dev and bonding dev 
will be in the upper dev list of eth0 and eth1? And br0 will be in the 
upper dev list of bond0 too?

I think it would be nice to describe the hierarchy after your patches.

Thanks!

