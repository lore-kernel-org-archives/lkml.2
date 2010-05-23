Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0EWGVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 02:21:16 -0400
Received: from mga05.intel.com ([192.55.52.89]:22697 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751797Ab0EWGVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 02:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,285,1272870000"; 
   d="scan'208";a="801036997"
Message-ID: <4BF8C954.90608@linux.intel.com>
Date: Sat, 22 May 2010 23:21:08 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: johnstul@us.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Frans Pop <elendil@planet.nl>, Johannes Berg <johannes.berg@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Wireless IBSS on Linux-2.6.34 broken by commit 3bbb9ec946428b96657126768f65487a48dd090c
References: <AANLkTikg6BEFCC-vwn3K96ZI-uiErg4SO8V701SWNkn0@mail.gmail.com>
In-Reply-To: <AANLkTikg6BEFCC-vwn3K96ZI-uiErg4SO8V701SWNkn0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2010 21:58, Jeff Chua wrote:
> Wireless IBSS on Linux-2.6.34 is broken. Reverting commit
> 3bbb9ec946428b96657126768f65487a48dd090c makes it work again. This was
> tested by bisecting the kernel.
>
> I'm using 6200 AGN ...
>
> cfg80211: Calling CRDA to update world regulatory domain
> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
> iwlagn: Copyright(c) 2003-2010 Intel Corporation
> iwlagn 0000:02:00.0: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
> iwlagn 0000:02:00.0: setting latency timer to 64
> iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
> iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> iwlagn 0000:02:00.0: irq 46 for MSI/MSI-X
> iwlagn 0000:02:00.0: loaded firmware version 9.193.4.1 build 19710

can you get us whole dmesg of two cases?
(just to know if there's something in surrounding messages of interest)
