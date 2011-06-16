Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1FPMD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:03:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37250 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab1FPMD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:03:57 -0400
X-Greylist: delayed 100046 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 08:03:57 EDT
X-AuditID: b753bd60-a3cafba0000019f4-bd-4df9f12aaa19
X-AuditID: b753bd60-a3cafba0000019f4-bd-4df9f12aaa19
Message-ID: <4DF9F11F.705@hitachi.com>
Date: Thu, 16 Jun 2011 21:03:43 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org,
        jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
In-Reply-To: <20110615153337.GA10160@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

(2011/06/16 0:33), Greg KH wrote:
> On Wed, Jun 15, 2011 at 05:16:28PM +0900, Nao Nishijima wrote:
>> Allow users to set the preferred name of device via sysfs interface.
>>
>> (Exsample) sda -> foo
>> # echo foo > /sys/block/sda/preferred_name
>>
>> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Suggested-by: Jon Masters <jcm@redhat.com>
>> Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
> 
> You don't document this new sysfs file (which is required), nor do you
> explain what it is for and how to use it.
> 
> Please do that in this patch, and in a Documentation/ABI/ file for any
> new sysfs file you create.
>

I'm afraid that my explanation was not enough.
I will add explanation to this patch and Documentation/ABI file.

> I still fail to understand how a "preferred" file will help anyone out
> here at all...
>

Let me explain, users cannot identify a device from a device name
because device names may change at each boot up time. If kernel show
preferred names in kernel messages, users can easily identify a device
from kernel messages.

> greg k-h
> 

Thanks,

-- 
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email： nao.nishijima.xt@hitachi.com
