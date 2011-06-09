Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1FIDPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:15:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42856 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1FIDPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ftFuCZSGNmU0A6/ZB/YjvKuP+u/7o3kmPvXJbVfI6XmAyTCyy5Pbg0cCUD4Tv+ChY4
         JbNsJnxT/8t2RotX45O2j905xBKxTdyAcipFewIQJbcw1abTq2WhLQYbzaKWW0Gb8ixY
         5vCbhJZLHMPp70X8mDQ3WWSRqW544VpYMQQyo=
MIME-Version: 1.0
In-Reply-To: <BANLkTimb-ankqNPyvcJMJY24zf9hB5AgOQ@mail.gmail.com>
References: <1307413455-6942-1-git-send-email-panweiping3@gmail.com>
	<4DF03894.2090202@gmail.com>
	<BANLkTimb-ankqNPyvcJMJY24zf9hB5AgOQ@mail.gmail.com>
Date: Thu, 9 Jun 2011 11:15:00 +0800
Message-ID: <BANLkTik4az0FF+AUo1SbmvhJhKP-bBG4Fw@mail.gmail.com>
Subject: Re: [PATCH] bonding: use new value of lacp_rate and ad_select
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: WeipingPan <panweiping3@gmail.com>
Cc: jpirko@redhat.com, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "<netdev@vger.kernel.org>, open list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 11:13 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Jun 9, 2011 at 11:05 AM, WeipingPan <panweiping3@gmail.com> wrote:
>> On 06/07/2011 10:24 AM, Weiping Pan wrote:
>>>
>>> There is bug that when you modify lacp_rate via sysfs,
>>> 802.3ad won't use the new value of lacp_rate to transmit packets.
>>> This is because port->actor_oper_port_state isn't changed.
>>>
>>> As for ad_select, it can work,
>>> but both struct bond_params and ad_bond_info have lacp_fast and ad_select,
>>> they are duplicate and need extra synchronization.
>>> 802.3ad can get them from bond_params directly every time.
>>>
>> Any comments ?
>>
>
> I think you'd better separate bug fix from cleanup's.
>

By the way, please mark the version of your patch in $subject,
in this case, V3. And describe what you changed from V2.
