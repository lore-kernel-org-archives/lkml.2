Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2ITRrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:47:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56926 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2ITRrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:47:51 -0400
MIME-Version: 1.0
In-Reply-To: <505B522F.9090808@asyr.hopto.org>
References: <505B522F.9090808@asyr.hopto.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Sep 2012 11:47:29 -0600
Message-ID: <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
To: Thanasis <thanasis@asyr.hopto.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 11:28 AM, Thanasis <thanasis@asyr.hopto.org> wrote:
> I have an Acer Aspire One notebook, and it has a NIC as shown below:
>
> # lspci |grep -i Realtek
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
>
> The driver module that I use is r8169. It works with 2.6 series of
> kernels, but it does *not* with the recent 3.x of kernels.
>
> Here is the output of ethtool with the 2.6.38 kernel:
>
> # ethtool eth0
> Settings for eth0:
>         Supported ports: [ TP MII ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>         Supported pause frame use: No
>         Supports auto-negotiation: Yes
>         Advertised link modes:  10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>         Advertised pause frame use: No
>         Advertised auto-negotiation: Yes
>         Link partner advertised link modes:  10baseT/Half 10baseT/Full
>                                              100baseT/Half 100baseT/Full
>         Link partner advertised pause frame use: No
>         Link partner advertised auto-negotiation: Yes
>         Speed: 100Mb/s
>         Duplex: Full
>         Port: MII
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: on
>         Supports Wake-on: pumbg
>         Wake-on: g
>         Current message level: 0x00000033 (51)
>                                drv probe ifdown ifup
>         Link detected: yes
>
> Question: Should I stick with 2.6 kernels, or are there any directions
> on how to make the NIC work with recent 3.x kernels?

Can you collect the complete dmesg logs from both 2.6.38 and the 3.x
kernel?  This should just work, so maybe something got broken.

Bjorn
