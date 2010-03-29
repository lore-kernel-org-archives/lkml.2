Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0C2Oym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:54:42 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:61668 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0C2Oyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:54:40 -0400
Message-ID: <4BB0BF28.5090505@petalogix.com>
Date: Mon, 29 Mar 2010 16:54:32 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>, netdev@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>,
       John Linn <John.Linn@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
Subject: Re: Network performance - iperf
References: <4BB09021.6020202@petalogix.com> <1269864994.2164.21.camel@edumazet-laptop>
In-Reply-To: <1269864994.2164.21.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le lundi 29 mars 2010 à 13:33 +0200, Michal Simek a écrit :
> 
>> Do you have any idea howto improve TCP/UDP performance in general?
>> Or tests which can point me on weak places.
> 
> Could you post "netstat -s" on your receiver, after fresh boot and your
> iperf session, for 32 MB and 256 MB ram case ?
> 

I am not sure if is helpful but look below.

Thanks,
Michal

~ # ./netstat -s
Ip:
     0 total packets received
     0 forwarded
     0 incoming packets discarded
     0 incoming packets delivered
     0 requests sent out
Icmp:
     0 ICMP messages received
     0 input ICMP message failed.
     ICMP input histogram:
     0 ICMP messages sent
     0 ICMP messages failed
     ICMP output histogram:
Tcp:
     0 active connections openings
     0 passive connection openings
     0 failed connection attempts
     0 connection resets received
     0 connections established
     0 segments received
     0 segments send out
     0 segments retransmited
     0 bad segments received.
     0 resets sent
Udp:
     0 packets received
     0 packets to unknown port received.
     0 packet receive errors
     0 packets sent
     RcvbufErrors: 0
     SndbufErrors: 0
UdpLite:
     InDatagrams: 0
     NoPorts: 0
     InErrors: 0
     OutDatagrams: 0
     RcvbufErrors: 0
     SndbufErrors: 0
error parsing /proc/net/snmp: Success



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
