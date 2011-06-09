Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1FIHJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:09:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37893 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab1FIHJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aDrfWwZH0R8lq6BCeYO9Zga7tYzDpaxUq/ZnZTNeM/IhVbsdBjIU75GVmcV0jYQeic
         0qelmc2/dkinVnyFdU3hX7BxbDk8iquYpZJtMC4viyxscjI243XdasSxL//eUQlmnx6S
         tiU2FMfD7shuMe8qofTtFRxt52u9rfcE0z5uQ=
Message-ID: <4DF071BE.1080006@gmail.com>
Date: Thu, 09 Jun 2011 15:09:50 +0800
From: WeipingPan <panweiping3@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: jpirko@redhat.com, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bonding: use new value of lacp_rate and ad_select
References: <1307413455-6942-1-git-send-email-panweiping3@gmail.com>	<4DF03894.2090202@gmail.com>	<BANLkTimb-ankqNPyvcJMJY24zf9hB5AgOQ@mail.gmail.com> <BANLkTik4az0FF+AUo1SbmvhJhKP-bBG4Fw@mail.gmail.com>
In-Reply-To: <BANLkTik4az0FF+AUo1SbmvhJhKP-bBG4Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 11:15 AM, Américo Wang wrote:
> On Thu, Jun 9, 2011 at 11:13 AM, Américo Wang<xiyou.wangcong@gmail.com>  wrote:
>> On Thu, Jun 9, 2011 at 11:05 AM, WeipingPan<panweiping3@gmail.com>  wrote:
>>> On 06/07/2011 10:24 AM, Weiping Pan wrote:
>>>> There is bug that when you modify lacp_rate via sysfs,
>>>> 802.3ad won't use the new value of lacp_rate to transmit packets.
>>>> This is because port->actor_oper_port_state isn't changed.
>>>>
>>>> As for ad_select, it can work,
>>>> but both struct bond_params and ad_bond_info have lacp_fast and ad_select,
>>>> they are duplicate and need extra synchronization.
>>>> 802.3ad can get them from bond_params directly every time.
>>>>
>>> Any comments ?
>>>
>> I think you'd better separate bug fix from cleanup's.
>>
> By the way, please mark the version of your patch in $subject,
> in this case, V3. And describe what you changed from V2.
ok, I will split the patch.

thanks
Weiping Pan
