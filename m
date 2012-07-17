Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2GQPDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:03:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43595 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2GQPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:03:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120717155539.1a6dbfc4@tux.DEF.witbe.net>
References: <CAMUfR_tzbEt0BTGwacHKQJQ13iGY8qLimNTFXM_dr5O-RwEgSA@mail.gmail.com>
	<1342531849.2626.605.camel@edumazet-glaptop>
	<CAMUfR_vpEJ=Spd+A5tunDxOttdVk_0RXWHX91HGUf9hGdEa10w@mail.gmail.com>
	<20120717155539.1a6dbfc4@tux.DEF.witbe.net>
Date: Tue, 17 Jul 2012 11:03:39 -0400
Message-ID: <CAMUfR_vYzFEfNzKtbS7KYmpVH7tZXHtc1EQcs9y6Q-=z2zwrcw@mail.gmail.com>
Subject: Re: PROBLEM: Can ping address, but traceroute gets ENETDOWN
From: Terry Phelps <tgphelps50@gmail.com>
To: Paul Rolland <rol@witbe.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 9:55 AM, Paul Rolland <rol@witbe.net> wrote:
> Hello,
>
> On Tue, 17 Jul 2012 09:41:27 -0400
> Terry Phelps <tgphelps50@gmail.com> wrote:
>
>> On Tue, Jul 17, 2012 at 9:30 AM, Eric Dumazet <eric.dumazet@gmail.com>
>> wrote:
>> > On Tue, 2012-07-17 at 09:04 -0400, Terry Phelps wrote:
>> >> socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
>> >> setsockopt(3, SOL_IP, IP_MTU_DISCOVER, [0], 4) = 0
>> >> setsockopt(3, SOL_SOCKET, SO_TIMESTAMP, [1], 4) = 0
>> >> fcntl(3, F_SETFL, O_RDONLY|O_NONBLOCK)  = 0
>> >> setsockopt(3, SOL_IP, IP_TTL, [1], 4)   = 0
>> >> setsockopt(3, SOL_IP, IP_RECVERR, [1], 4) = 0
>> >> connect(3, {sa_family=AF_INET, sin_port=htons(33434),
>> >> sin_addr=inet_addr("192.168.118.22")}, 28) = 0
>> >> sendto(3, "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_"..., 40, 0, NULL, 0) = -1
>> >> ENETDOWN (Network is down)
>
> ENETDOWN should mean your interface is no more in the UP status.
>
> Could it be you have some processes running that could turn down and up
> your interfaces ? Anything in /var/log/messages about eth0 ?
>
> Paul

(Paul, I'm resending this so it goes to the list.)

The interface is certainly up, because when I'm doing the traceroute
that gets the ENETDOWN, I'm SSH'ed into the box through eth0. And
other processes on the machines are running just fine.

And no, there are no messages in /var/log/* about eth0 that I've ever
seen. Everything works just fine except:
1. My desktop can't ping the box.
2. The box can't traceroute (but CAN ping!) my desktop.
