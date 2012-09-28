Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2I1GoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:44:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:4975 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2I1GoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:44:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208";a="227608242"
Message-ID: <50654730.6010204@linux.intel.com>
Date: Fri, 28 Sep 2012 14:44:00 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120306 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, tshimizu818@gmail.com,
        linux-kernel@vger.kernel.org, haicheng.lee@gmail.com
Subject: Re: [PATCH 2/2] Fix a typo in PTP_1588_CLOCK_PCH Kconfig help info.
References: <506009A4.8000202@linux.intel.com>	<50600A49.7040902@linux.intel.com>	<5060F9C4.4050303@linux.intel.com> <20120927.180640.447002776076460117.davem@davemloft.net>
In-Reply-To: <20120927.180640.447002776076460117.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 06:06 AM, David Miller wrote:
>> -	  will be called ptp_pch.
>> +	  will be called by pch_ptp.
>
> The original sentence is correct, it is stating the name of the module
> that will be built not the module that will call it.
You're right.

> Rather, the "pch_ptp" is what might need to be adjusted.
No need, the output is ptp_pch.ko.

So pls. ignore this patch. sorry for the bothering.

-haicheng
