Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1JVINx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 04:13:53 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4447 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1JVINw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 04:13:52 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Nico Schottelius" <nico-linux-20111017@schottelius.org>,
        "gregkh@suse.de" <gregkh@suse.de>
cc: "Eric Dumazet" <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 22 Oct 2011 01:13:34 -0700
Subject: RE: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Thread-Topic: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Thread-Index: AcyQXmpWUYe8DDz0ReSE9VT5bXYpxgAMNtPA
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0E147BCB@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20111019123602.GA11883@schottelius.org>
 <1319028563.8416.1.camel@edumazet-laptop>
 <20111019130749.GD11883@schottelius.org>
 <20111019142837.GA1414@schottelius.org> <4E9EE20F.1030403@broadcom.com>
 <20111019145501.GB1414@schottelius.org> <4E9EFF51.6000104@broadcom.com>
 <20111019214250.GC2432@schottelius.org> <4E9FBFA7.4040502@broadcom.com>
 <20111022015945.GC26186@ethz.ch>
In-Reply-To: <20111022015945.GC26186@ethz.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 62BCA3623JW8254856-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nico Schottelius [mailto:nico-linux-20111017@schottelius.org]
> Sent: zaterdag 22 oktober 2011 4:00
> 
> Hey Arend,
> 
> it seems that your patch really solves this problem.

Great. This fix is in linux-next tree.

Greg,

This problem causes packets to get dropped on 5GHz. Should I
sent a patch for 3.1 (staging-linus) for this? It is already
fixed in wireless-next.
 
> I've got a new one now, though :-)

Ok. Not sure which universal law this is, but let's have a look.

> After several suspend/resume cycles, my card often reconnects to my AP
> that is only several meters (2) away. If the connection is established,
> I've a very laggy connection to the AP:
> 
> 64 bytes from 192.168.42.1: icmp_req=1154 ttl=64 time=10839 ms
> 64 bytes from 192.168.42.1: icmp_req=1155 ttl=64 time=9841 ms
> ...
> 64 bytes from 192.168.42.1: icmp_req=1164 ttl=64 time=2814 ms
> 64 bytes from 192.168.42.1: icmp_req=1165 ttl=64 time=16785 ms
> 64 bytes from 192.168.42.1: icmp_req=1166 ttl=64 time=20767 ms
> 
> Attached are the usual suspect outputs.
> This time I'm on 2.432 Ghz.

I will dig into it.

Gr. AvS

