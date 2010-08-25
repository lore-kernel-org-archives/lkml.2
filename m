Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0HYIz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:55:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54370 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0HYIz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:55:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <4C715027.9060602@superonline.com>
References: <20100820115449.5FF1.A69D9226@jp.fujitsu.com> <4C715027.9060602@superonline.com>
Message-Id: <20100825175034.F3EA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 25 Aug 2010 17:55:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > % cat /proc/meminfo
> 
> MemTotal:        3104484 kB
> MemFree:         2817616 kB
> Buffers:           31156 kB
> Cached:           142124 kB
> SwapCached:            0 kB
> Active:           116464 kB
> Inactive:         137424 kB
> Active(anon):      80852 kB
> Inactive(anon):    24820 kB
> Active(file):      35612 kB
> Inactive(file):   112604 kB
> Unevictable:          32 kB
> Mlocked:              32 kB
> HighTotal:       2226632 kB
> HighFree:        1994008 kB
> LowTotal:         877852 kB
> LowFree:          823608 kB
> SwapTotal:       1999540 kB
> SwapFree:        1999540 kB

!! Your swap partition is smaller than physical memory. As far as I know,
swap partition need physcal-mem x 2 size. Can you please try to change 
swap configuration?

Rafael, please correct me if I'm talking wrong.

Thanks.



