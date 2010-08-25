Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0HYRdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 13:33:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45163 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab0HYRdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 13:33:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Date: Wed, 25 Aug 2010 19:31:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20100820115449.5FF1.A69D9226@jp.fujitsu.com> <4C715027.9060602@superonline.com> <20100825175034.F3EA.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100825175034.F3EA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008251931.29835.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 25, 2010, KOSAKI Motohiro wrote:
> > > % cat /proc/meminfo
> > 
> > MemTotal:        3104484 kB
> > MemFree:         2817616 kB
> > Buffers:           31156 kB
> > Cached:           142124 kB
> > SwapCached:            0 kB
> > Active:           116464 kB
> > Inactive:         137424 kB
> > Active(anon):      80852 kB
> > Inactive(anon):    24820 kB
> > Active(file):      35612 kB
> > Inactive(file):   112604 kB
> > Unevictable:          32 kB
> > Mlocked:              32 kB
> > HighTotal:       2226632 kB
> > HighFree:        1994008 kB
> > LowTotal:         877852 kB
> > LowFree:          823608 kB
> > SwapTotal:       1999540 kB
> > SwapFree:        1999540 kB
> 
> !! Your swap partition is smaller than physical memory. As far as I know,
> swap partition need physcal-mem x 2 size. Can you please try to change 
> swap configuration?
> 
> Rafael, please correct me if I'm talking wrong.

No, we only save 50% of RAM (at most) during hibernation.

Thanks,
Rafael
