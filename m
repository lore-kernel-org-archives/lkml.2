Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2JWQO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:14:26 -0400
Received: from mail.candelatech.com ([208.74.158.172]:41606 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2JWQOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:14:25 -0400
Message-ID: <5086C256.20202@candelatech.com>
Date: Tue, 23 Oct 2012 09:14:14 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: cardoe@cardoe.com, kaber@trash.net, netdev@vger.kernel.org,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
References: <1350885237-12998-1-git-send-email-cardoe@cardoe.com> <20121023.023647.2164665243829038911.davem@davemloft.net>
In-Reply-To: <20121023.023647.2164665243829038911.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 11:36 PM, David Miller wrote:
> From: Doug Goldstein <cardoe@cardoe.com>
> Date: Mon, 22 Oct 2012 00:53:57 -0500
>
>> Sets the sysfs device_type to 'vlan' for udev. This makes it easier for
>> applications that query network information via udev to identify vlans
>> instead of using strrchr().
>>
>> Signed-off-by: Doug Goldstein <cardoe@cardoe.com>
>
> You're extremely misguided.  This change, in fact, makes it ten times
> harder for such applications to query such devices.

If the application doesn't care, it can use the old way (which at least
for me, involves string-comparing the driver name ethtool returns, which
sucks at best).

And applications that care might suddenly have more features, or be more
efficient when running on newer kernels..

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

