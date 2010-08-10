Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0HJAmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 20:42:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:64270 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab0HJAmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 20:42:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,345,1278313200"; 
   d="scan'208";a="543485727"
Message-ID: <4C60A05F.1090506@intel.com>
Date: Mon, 09 Aug 2010 17:42:07 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        "Latif, Faisal" <faisal.latif@intel.com>,
        "Tung, Chien Tin" <chien.tin.tung@intel.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: i386 allmodconfig, current mainline
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
In-Reply-To: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/2010 4:43 PM, Andrew Morton wrote:
>
> Guys.  What's goin' on out there?
[..]
>
> drivers/dma/timb_dma.c: In function 'td_fill_desc':
> drivers/dma/timb_dma.c:203: warning: cast to pointer from integer of different size

The fix for this one is pending in my 2.6.36 pull request.  I added the 
missing ARCH=i386, CONFIG_HIGHMEM64G=y case to my build regression script.

--
Dan
