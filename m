Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2APQfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:35:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:38120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab2APQfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:35:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="107619365"
Message-ID: <4F1451BD.9030904@linux.intel.com>
Date: Mon, 16 Jan 2012 08:35:09 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Darren Hart <dvhart@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of failing
 probe
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AF47@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AF47@saturn3.aculab.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2012 8:20 AM, David Laight wrote:
>  
>> the tricky thing with embedded hw like this is that all devices might
>> end up with the same, read-only filesystem, so storing the 
>> mac on the FS
>> and then loading it from there into the HW is... suboptimal.
>>
>> Would be very nice if busybox had a command that would check the mac
>> from each IF, and created the random mac from userspace 
>> automatically...
> 
> Since multiple interfaces on a single system are unlikely
> to be connected to the same LAN segment, it doesn't really
> matter if they use same MAC address.

I think you missed the point. All embedded devices have the same fs, so
if you have 2 boxes of the same model/brand on the same network, they'd
have the same MAC. That's generally frowned upon by network
administrators ;-)
