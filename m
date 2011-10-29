Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864Ab1J2SaD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 14:30:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40059 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1J2SaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 14:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <20111024.182142.2299822581628382143.davem@davemloft.net>
References: <1319272916-5541-1-git-send-email-kth3321@gmail.com>
	<20111024.182142.2299822581628382143.davem@davemloft.net>
Date: Sun, 30 Oct 2011 03:29:59 +0900
Message-ID: <CAOkfWjf722hrPs4_Sj2vACHMD_8UaEx7pHN6JaLZ+ysFdaELcg@mail.gmail.com>
Subject: Re: [PATCH net-next] w5300: add WIZnet W5300 Ethernet driver
From: Taehun Kim <kth3321@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, romieu@fr.zoreil.com,
        suhwan@wiznet.co.kr, bongbong@wiznet.co.kr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/25 David Miller <davem@davemloft.net>:
> From: Taehun Kim <kth3321@gmail.com>
> Date: Sat, 22 Oct 2011 17:41:56 +0900
>
>> +struct wiz_private {
>> +     void __iomem *base;
>> +     struct net_device *dev;
>> +     u8 rxbuf_conf[MAX_SOCK_NUM];
>> +     u8 txbuf_conf[MAX_SOCK_NUM];
>> +     struct net_device_stats stats;
>> +     struct napi_struct napi;
>> +     spinlock_t lock;
>> +     u32 msg_enable;
>> +};
>
> You don't need to have a private net_device_stats, just use the
> one in struct net_device, and then you can also get rid of your
> private ->ndo_get_stats() method.
>

Thank you for your feedback :)

I am working on this drive by referencing other Ethernet drivers.
I have one question.

Should I suggest the updated driver patch to this thread or new
thread?
