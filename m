Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab1FIHXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:23:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59359 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1FIHXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XNnRp9t7JcZoZQLUEoL0p4GaTWHezjyGwswsVJDi8xpuDpFWSE1nlcj13bJ/w7gEuY
         9pV1jM5/ctqDsVp1lgdRGnxPgwDhPvU4BgMX3ej/SnrMvwNo5nzX8IDY+FMsbW2hAzYu
         iTRYWf1BQXSubpwbBFbRq+0VtWZBhaqsyoAjU=
Message-ID: <4DF0750A.7030307@gmail.com>
Date: Thu, 09 Jun 2011 15:23:54 +0800
From: WeipingPan <panweiping3@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] bonding: delete two unused variables
References: <cover.1307587586.git.panweiping3@gmail.com> <BANLkTi=xoCJUZAfHBR18bs_WmXwD7rt58g@mail.gmail.com>
In-Reply-To: <BANLkTi=xoCJUZAfHBR18bs_WmXwD7rt58g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 11:19 AM, Américo Wang wrote:
> On Thu, Jun 9, 2011 at 10:51 AM, Weiping Pan<panweiping3@gmail.com>  wrote:
>> Delete two unused variables in bonding.
>>
>> Weiping Pan (2):
>>   bonding: delete unused ad_timer
>>   bonding: delete unused arp_mon_pt
>>
> Both look good to me,
>
> Reviewed-by: WANG Cong<xiyou.wangcong@gmail.com>
>
> Thanks.
thanks,
But I move these two patches into another patchset,
the title is "[PATCH v4 net-next 0/5] bonding:use latest lacp_rate and 
ad_select and delete unused ad_timer and arp_mon_pt"

Hope it will be convenient to be reviewed and merged, so forget these 
two patches.

thanks
Weiping Pan
