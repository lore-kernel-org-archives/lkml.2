Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3AHA1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:27:07 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54412 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3AHA1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:27:05 -0500
X-IronPort-AV: E=Sophos;i="4.84,427,1355126400"; 
   d="scan'208";a="15000424"
X-IronPort-AV: E=Sophos;i="4.84,427,1355126400"; 
   d="scan'208";a="372494177"
Message-ID: <50EB67D5.8070001@qti.qualcomm.com>
Date: Mon, 7 Jan 2013 16:27:01 -0800
From: Max Krasnyansky <maxk@qti.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: why does kernel 3.8-rc1 put all TAP devices into state RUNNING
 during boot
References: <50E7FD79.1080605@gmx.de>
In-Reply-To: <50E7FD79.1080605@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 02:16 AM, Toralf Förster wrote:
> At my stable Gentoo Linux I'm observed a change behaviour for the
> configured TAP devices after the boot process.
> 
> $ diff 3.7.1 3.8.0-rc1+ | grep UP
>- br0: flags=4355<UP,BROADCAST,PROMISC,MULTICAST>  mtu 1500
>+ br0: flags=4419<UP,BROADCAST,RUNNING,PROMISC,MULTICAST>  mtu 1500
>- tap0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
>+ tap0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
> 
> May I ask you if this changed behaviour is intended ?

I'm not aware of any changes in this behavior.
btw Looks like it changed for your bridge interfaces as well. So it's not really
specific to the TAP devices.

Someone from netdev would know :)

Max



