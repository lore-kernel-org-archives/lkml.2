Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2FSJlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:41:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58814 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2FSJli convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120619085137.337838c0@xenia.leun.net>
References: <20120619085137.337838c0@xenia.leun.net>
Date: Tue, 19 Jun 2012 15:11:38 +0530
Message-ID: <CAD2nsn1b6in_yA1b+o=SoXD3iJPddoF4PeCQ3qhFNWqfZxq8pQ@mail.gmail.com>
Subject: Re: ath9k_htc: Every 2nd packet 1000ms delayed in recent kernels
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Michael Leun <lkml20120218@newton.leun.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 19, 2012 at 12:21 PM, Michael Leun
<lkml20120218@newton.leun.net> wrote:
> Hi,
>
> ne-wlan1@elektra:/home/ml4> ping 192.168.2.1
> PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
> 64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=2010 ms
> 64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=1011 ms
> 64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=11.5 ms
> 64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=1.12 ms
> 64 bytes from 192.168.2.1: icmp_seq=5 ttl=64 time=1002 ms
> 64 bytes from 192.168.2.1: icmp_seq=6 ttl=64 time=3.83 ms
> 64 bytes from 192.168.2.1: icmp_seq=7 ttl=64 time=1003 ms
> 64 bytes from 192.168.2.1: icmp_seq=8 ttl=64 time=4.10 ms
> 64 bytes from 192.168.2.1: icmp_seq=9 ttl=64 time=1003 ms
> 64 bytes from 192.168.2.1: icmp_seq=10 ttl=64 time=3.95 ms
> 64 bytes from 192.168.2.1: icmp_seq=11 ttl=64 time=1003 ms
> 64 bytes from 192.168.2.1: icmp_seq=12 ttl=64 time=3.78 ms
>
>
> Please note the additional delay of ~1000ms every 2nd packet. This is
> Kernel 3.4.3, have seen it in 3.4.2 also. Does NOT happen in 3.3.1.
>
> Is this Issue already known? If so, I can save the work bisecting...

looks like some one reported this bug in kernel bugzilla. would be
saving us lot of time
if you can bisect it!

>
> Happens with two different ath9k_htc cards:
>
> Bus 002 Device 012: ID 0846:9018 NetGear, Inc. WNDA3200 802.11abgn Wireless Adapter [Atheros AR7010+AR9280]
> Bus 002 Device 004: ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]
>
> Does NOT happen with an atk9k (mini pci express) card.

thanks for the info!

>
> --
> MfG,
>
> Michael Leun
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
