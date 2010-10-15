Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0JOUIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:08:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:56702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803Ab0JOUIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:08:40 -0400
Message-ID: <4CB8B4B8.8090501@kernel.org>
Date: Fri, 15 Oct 2010 22:08:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH v2.6.36-rc7 2/2] shpchp: update workqueue usage
References: <4CB86966.5020606@kernel.org>	<4CB8698A.8030202@kernel.org> <20101015125257.73e8d8df@jbarnes-desktop>
In-Reply-To: <20101015125257.73e8d8df@jbarnes-desktop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 20:08:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/15/2010 09:52 PM, Jesse Barnes wrote:
>> * Rename shpchp_wq to shpchp_ordered_wq and add non-ordered shpchp_wq
>>   which is used instead of the system workqueue.  This is to remove
>>   the use of flush_scheduled_work() which is deprecated and scheduled
>>   for removal.
>>
>> * With cmwq in place, there's no point in creating workqueues lazily.
>>   Create both shpchp_wq and shpchp_ordered_wq upfront.
>>
>> * Include workqueue.h from shpchp.h.
> 
> Applied these two, thanks.  I think Kenji-san will probably let me know
> if pciehp suddenly breaks as a result. :)

Just in case, these are in no way aimed for v2.6.36.  They are at the
earliest for v2.6.37-rc1.  Thanks a lot.

-- 
tejun
