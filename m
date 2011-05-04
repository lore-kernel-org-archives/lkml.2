Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1EDQA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:00:57 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:48143 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1EDQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:00:54 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "jdossantos@docs.homelinux.org" <jdossantos@docs.homelinux.org>
CC: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Error in Hyper-V modules hv_vmbus
Thread-Topic: Error in Hyper-V modules hv_vmbus
Thread-Index: AQHMCkBpETUemc5uTUuEnNLkft8sE5R8045Q
Date: Wed, 4 May 2011 16:00:52 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C562498A3FF3@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <0e67fbb5ce27bd8d1210f0b7b8d5069c@docs.homelinux.org>
In-Reply-To: <0e67fbb5ce27bd8d1210f0b7b8d5069c@docs.homelinux.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.75]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p44G1BQh032734




> -----Original Message-----
> From: jdossantos@docs.homelinux.org
> [mailto:jdossantos@docs.homelinux.org]
> Sent: Wednesday, May 04, 2011 2:48 AM
> To: Hank Janssen
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org
> Subject: Re: Error in Hyper-V modules hv_vmbus
> > Hank.
> 
>  Here is my step by step protocol:

Thanks for the detailed setup. I will be trying it with this.

>  lsmod | grep hv_
>  hv_timesource           1055  0 [permanent]
>  hv_vmbus               48554  1
> 
>  In the logs and with lsmod i see the timesource module running, but
> the
>  time is not in sync with the windows host.
>  Shutdown function also dosn't work, seems that nothing of the
>  integrated components are working..hv_netvsc,hv_blkvsc,hv_storvsc are
>  not
>  loaded?! But modinfo provides information:

Timesource makes sure that the clock does not drift and uses Hyper-V for
Its stable time source. 

The setting of the clock equal to the host is provided by the hv_utils.ko
Module. This module also provides heartbeat, shutdown and KVP functionality.

 
>  After that I enabled the synthetic network card, but also here..it
>  doesn't work and I don't see any hv_netvsc
>  module loaded, so I tried to load it "by hand" with modprobe
>  hv_netvsc..but I get a modprobe timeout and nothing happens..

I should know more in the next day or so when I get a VM up and running.

It works fine on Ubuntu, I submitted a few patches to them a few weeks ago
To fix some other problems (these patches are already in mainline)

Hank.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
