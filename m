Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab2DLLgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:36:47 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36020 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2DLLgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:36:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+pWcCaExwnth+KtFEyJhqODWbPsMA5O+toooF+mjueDg3GxuA@mail.gmail.com>
References: <CA+pWcCZ28ByXuOu72FAAAQAPny3O0WDvd+vv1TryXw+9DMKwiA@mail.gmail.com>
	<4F69EC88.2070006@redhat.com>
	<CA+pWcCaExwnth+KtFEyJhqODWbPsMA5O+toooF+mjueDg3GxuA@mail.gmail.com>
Date: Thu, 12 Apr 2012 13:36:45 +0200
Message-ID: <CA+pWcCZ66+=YYH-orwP71eTcyeaDzWF6bQ4viPCC=szPLhUXow@mail.gmail.com>
Subject: Re: extreme system load [kswapd]
From: =?ISO-8859-2?Q?Karol_=A9ebesta?= <sebesta.karol@gmail.com>
To: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# cat /proc/sys/vm/zone_reclaim_mode
0
#

The value is set to zero, and we have these problems.... interesting...

Regards,

Karol Sebesta

2012/4/12 Karol ©ebesta <sebesta.karol@gmail.com>:
> Hello Rik,
>
> Thank you for answer, but now we are facing to another interesting
> issue on our redhat 5.6 server.
>
> It seems that linux dropped almost all disk cache and now it trying to
> gain disk cache space by swapping. That is the reason why kswapd
> process loads the system.
>
> ### as you can see almost all RAM is free ( that is bad ) - some time
> ago there was all RAM cached in disk cache
>
> [root@dusu0216 ~]# free -m
>             total       used       free     shared    buffers     cached
> Mem:        128861      29814      99047          0        108      20186
> -/+ buffers/cache:       9519     119342
> Swap:        81919      16614      65305
> [root@dusu0216 ~]#
>
>
> Do you think that can be a problem with NUMA nodes or what can be the
> reason that Linux itself dropped almost all disk cache?
>
> Thank you.
>
> Regards,
>
> Karol Sebesta



-- 
S pozdravom

Karol ©ebesta
