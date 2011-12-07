Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1LGC4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:56:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:52901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab1LGC4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:56:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="84290704"
Message-ID: <4EDED5B3.3000200@linux.intel.com>
Date: Wed, 07 Dec 2011 10:55:47 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Nico Schottelius <nico-linux-20111201@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: MCE/Hardware errors/Temperature on MacBookAir 4,2
References: <20111206082953.GA1945@schottelius.org>
In-Reply-To: <20111206082953.GA1945@schottelius.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/12/6 16:29, Nico Schottelius 写道:
> Hello,
>
> with the previous kernel compiling a new kernel, I get these
> messages in dmesg:
>
> [170745.226310] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
> [170942.965765] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1)
> [170942.965770] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1)
> [170942.965776] CPU2: Package temperature above threshold, cpu clock throttled (total events = 1)
> [170942.965781] CPU0: Package temperature above threshold, cpu clock throttled (total events = 1)
> [170942.965785] CPU1: Package temperature above threshold, cpu clock throttled (total events = 1)
> [170942.965791] CPU3: Package temperature above threshold, cpu clock throttled (total events = 1)
> [170942.966766] CPU3: Core temperature/speed normal
> [170942.966770] CPU1: Core temperature/speed normal
> [170942.966775] CPU2: Package temperature/speed normal
> [170942.966779] CPU0: Package temperature/speed normal
> [170942.966782] CPU1: Package temperature/speed normal
> [170942.966787] CPU3: Package temperature/speed normal
> [171033.962774] [Hardware Error]: Machine check events logged
>
> Shall I consider these informative/warning/dangerous?
>
> In any case, I'm wondering whath the hardware error may be
> and whether it's really a hardware error or OS problem?
>
> Cheers,
>
> Nico
>

pls check this thread:
https://lkml.org/lkml/2011/11/14/239
