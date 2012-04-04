Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2DDMVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:21:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:25560 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2DDMVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:21:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126965197"
Message-ID: <4F7C3CE2.5070803@intel.com>
Date: Wed, 04 Apr 2012 15:21:54 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linaro-kernel@lists.linaro.org, linux-mm@kvack.org,
        "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        kernel-team@android.com
Subject: Re: swap on eMMC and other flash
References: <201203301744.16762.arnd@arndb.de> <201203301850.22784.arnd@arndb.de>
In-Reply-To: <201203301850.22784.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/03/12 21:50, Arnd Bergmann wrote:
> (sorry for the duplicated email, this corrects the address of the android
> kernel team, please reply here)
> 
> On Friday 30 March 2012, Arnd Bergmann wrote:
> 
>  We've had a discussion in the Linaro storage team (Saugata, Venkat and me,
>  with Luca joining in on the discussion) about swapping to flash based media
>  such as eMMC. This is a summary of what we found and what we think should
>  be done. If people agree that this is a good idea, we can start working
>  on it.

There is mtdswap.

Also the old Nokia N900 had swap to eMMC.

The last I heard was that swap was considered to be simply too slow on hand
held devices.

As systems adopt more RAM, isn't there a decreasing demand for swap?
