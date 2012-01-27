Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2A0DMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:12:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35368 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2A0DL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:11:59 -0500
MIME-Version: 1.0
In-Reply-To: <20120127015015.GA23291@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	<CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	<20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	<CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	<20120126003735.GA2346@gamma.logic.tuwien.ac.at>
	<CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
	<CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
	<20120126232555.GB16330@gamma.logic.tuwien.ac.at>
	<20120127015015.GA23291@gamma.logic.tuwien.ac.at>
Date: Thu, 26 Jan 2012 19:11:57 -0800
Message-ID: <CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Emmanuel,
>
> On Fr, 27 Jan 2012, Norbert Preining wrote:
>> First tests are promising, after reboot it was working immediately
>> without need to rfkill block/unblock. lso after suspend and resume.
>>
>> Will test more the next days and report back.
>
> Unfortunately, at the university it is still a complete no-go.
> Usually the connection works for a short time, then breaks down.
> After that even unloading and loading the module did not reactivate
> it, I cannot get a connection at all. But other units, or with
> older kernel (it was 2.6.3X AFAIR) it was working without a glitch.
>
> I uploaded a syslog output including kernel and network manager logs
> to
>        http://www.logic.at/people/preining/syslog.log
> (new one). This shows a session from loading the module up to giving up.
>

I glanced at the logs, and they look healthy from the wifi driver
side. You just don't get any reply to DHCP_DISCOVER apparently... can
you get a sniffer ?
I am pretty sure that the packet in sent in the air, but if you can
get a capture of that we could check that out.
