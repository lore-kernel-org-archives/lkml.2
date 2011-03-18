Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1CROHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:07:09 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:41663 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754075Ab1CROHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:07:04 -0400
Message-ID: <4D836701.50000@example.com>
Date: Fri, 18 Mar 2011 15:06:57 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: LKML <linux-kernel@vger.kernel.org>
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Firmware works I think, why my networking fails?
References: <4D83432A.10504@example.com>
In-Reply-To: <4D83432A.10504@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 7422776611026727192
X-Ovh-Remote: 178.36.5.172 (178-36-5-172.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2011 12:34, Piotr Hosowicz wrote:
> Hello,
>
> The 2.6.39-git3 kernel works as usual, mii-tool shows that there is
> link. Any newer kernel fails this test. What can I do? What extra
> information would you need?

Here is some more ethtool info, when cannot connect through ADSL via eth0:

aapi205:~# cat eth0.et.BAD.txt
Settings for eth0:
         Supported ports: [ TP MII ]
         Supported link modes:   10baseT/Half 10baseT/Full
                                 100baseT/Half 100baseT/Full
                                 1000baseT/Half 1000baseT/Full
         Supports auto-negotiation: Yes
         Advertised link modes:  1000baseT/Half 1000baseT/Full
         Advertised pause frame use: No
         Advertised auto-negotiation: Yes
         Speed: 10Mb/s
         Duplex: Half
         Port: MII
         PHYAD: 0
         Transceiver: internal
         Auto-negotiation: on
         Supports Wake-on: pumbg
         Wake-on: g
         Current message level: 0x00000033 (51)
         Link detected: no

Regards,

Piotr Hosowicz

-- 
TV: "Grucha³a jest taka, ¿e cieszy siê z ka¿dego pchniêcia."
NP: Banda Do Sol - Tempo
NB: 2.6.38-git3
