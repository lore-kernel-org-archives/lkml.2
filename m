Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab0JOV0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:26:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38540 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab0JOV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:26:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CB8C6B3.9000308@jp.fujitsu.com>
Date: Sat, 16 Oct 2010 06:25:07 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>
CC: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7 2/2] shpchp: update workqueue usage
References: <4CB86966.5020606@kernel.org>	<4CB8698A.8030202@kernel.org> <20101015125257.73e8d8df@jbarnes-desktop>
In-Reply-To: <20101015125257.73e8d8df@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/16 4:52), Jesse Barnes wrote:
> On Fri, 15 Oct 2010 16:47:38 +0200
> Tejun Heo<tj@kernel.org>  wrote:
>
>> * Rename shpchp_wq to shpchp_ordered_wq and add non-ordered shpchp_wq
>>    which is used instead of the system workqueue.  This is to remove
>>    the use of flush_scheduled_work() which is deprecated and scheduled
>>    for removal.
>>
>> * With cmwq in place, there's no point in creating workqueues lazily.
>>    Create both shpchp_wq and shpchp_ordered_wq upfront.
>>
>> * Include workqueue.h from shpchp.h.
>
> Applied these two, thanks.  I think Kenji-san will probably let me know
> if pciehp suddenly breaks as a result. :)
>

Thank you for the patch. I'll review and test it.
Yeah, I'll let you know if I find something, Jesse.

Regards,
Kenji Kaneshige


