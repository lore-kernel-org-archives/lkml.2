Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1BMSDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 13:03:05 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45024 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1BMSDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 13:03:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lpg0fSzqvu25N3yF4B2xgW8LMYAU7RRsmOH0RN/GWRFO7XYW67ktUq/W/s+wgxHbfc
         UjwGY7zJmnrLNnfaD2oYe28lu2gA10D7AuyhGtIrN9qgJbd11H8EudOpEE2rU57dGjdq
         wpPeHAT9VAmCQPuEBqlqKdhJf8ZdtUQbbLpEQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTikTw71-mv9WsPT8PxC1a1nwEJ=x0UNDhVQGP1A6@mail.gmail.com>
References: <AANLkTin7GBSTcfZgr_9sNZ8CPMkW7Vstni+fs2v1-ink@mail.gmail.com>
 <1297581470.2510.18.camel@edumazet-laptop> <20110213135600.GA11382@electric-eye.fr.zoreil.com>
 <AANLkTikTw71-mv9WsPT8PxC1a1nwEJ=x0UNDhVQGP1A6@mail.gmail.com>
From: Seblu <seblu@seblu.net>
Date: Sun, 13 Feb 2011 19:02:38 +0100
X-Google-Sender-Auth: 6e2q-QQkOUVwn42SsA90hBYqeI8
Message-ID: <AANLkTikLOJ-XcwfdbWS19DKzh2s91tn5pQjJe0+CeAN-@mail.gmail.com>
Subject: Re: Mass udp flow reboot linux with RealTek RTL-8169 Gigabit
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Ivan Vecera <ivecera@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 6:27 PM, Seblu <seblu@seblu.net> wrote:
> On Sun, Feb 13, 2011 at 2:56 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
>> Eric Dumazet <eric.dumazet@gmail.com> :
>> If it still does not perform better, please include the XID line of
>> the r8169 driver from dmesg.
>>
> I've tryed on archlinux i686 distro with 2.6.37 and host reboot like
> under debian.
>
> After this, i tryed  wiith a 2.6.38-rc4 (amd64), which include your
> recent patchs.
>
> # dmesg|grep -i xid
> r8169 0000:04:00.0: eth0: RTL8168b/8111b at 0xffffc90005260000,
> 1c:6f:65:56:d9:17, XID 0c200000 IRQ 47
>
> NIC seems to be reset frequently but host stop rebooting. \o//
ok after about 1 hour of iperf, host reboot.

-- 
Sébastien Luttringer
www.seblu.net
