Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2JSHsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:48:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:11563 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756981Ab2JSHrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:47:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6029857"
Message-ID: <5080FED8.8070201@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 15:18:48 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 6/9] memory-hotplug: update mce_bad_pages when removing
 the memory
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com> <1350629202-9664-7-git-send-email-wency@cn.fujitsu.com> <CAHGf_=oB5bDaw4JepMuKcEUM3=GaEuy8NZb+7G4uR3=-hYh8Dg@mail.gmail.com>
In-Reply-To: <CAHGf_=oB5bDaw4JepMuKcEUM3=GaEuy8NZb+7G4uR3=-hYh8Dg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 15:12:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 15:12:58,
	Serialize complete at 2012/10/19 15:12:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/19/2012 03:06 PM, KOSAKI Motohiro Wrote:
> On Fri, Oct 19, 2012 at 2:46 AM,  <wency@cn.fujitsu.com> wrote:
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> When we hotremove a memory device, we will free the memory to store
>> struct page. If the page is hwpoisoned page, we should decrease
>> mce_bad_pages.
> 
> I think [5/9] and [6/9] should be fold. Their two patches fix one
> issue. (current
> hwpoison doesn't support memory offline)
> 

OK, I will fold them into one patch soon.

Thanks
Wen Congyang
