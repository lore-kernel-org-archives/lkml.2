Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1LBL1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:27:24 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1610 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab1LBL1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:27:23 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4ED8B610.2010703@broadcom.com>
Date: Fri, 2 Dec 2011 12:27:12 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Nico Schottelius" <nico-linux-20111201@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        b43-dev@lists.infradead.org
Subject: Re: BCM43224: 00:00:00:00:00:00 address
 (3.2.0-rc3-00099-g883381d)
References: <20111201224851.GB20536@ethz.ch>
In-Reply-To: <20111201224851.GB20536@ethz.ch>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62C6684F5041311203-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 11:48 PM, Nico Schottelius wrote:
> Hello,
> 
> just received another version of the macbook air, which is
> labeled MacBookAir4,2 again.
> 
> This time I'm on Linus' 3.2.0-rc3-00099-g883381d and cannot
> use the integrated wifi:
> 
> [23:43] brief:drivers# ip l show wlan0 
> 2: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
>     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
> [23:43] brief:drivers# ip l s wlan0 up
> RTNETLINK answers: Cannot assign requested address
> 
> It seems this time b43 is responsible for the card, not brcmsmac
> anymore (superseeded it seems).
> 
> Is there a working tree out there somewhere? :-)
> 
> Cheers,
> 
> Nico
> 

Hi Nico,

Have you tried the brcmsmac driver?

Gr. AvS

