Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2LLKr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:47:59 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:26235 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LLKr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:47:58 -0500
Message-ID: <50C860AD.5040504@huawei.com>
Date: Wed, 12 Dec 2012 18:47:09 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, WuJianguo <wujianguo@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 3/3] MCE: fix an error of mce_bad_pages statistics
References: <50C7FB85.8040008@huawei.com> <20121212102523.GA8760@liondog.tnic>
In-Reply-To: <20121212102523.GA8760@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/12 18:25, Borislav Petkov wrote:

> On Wed, Dec 12, 2012 at 11:35:33AM +0800, Xishi Qiu wrote:
>> Since MCE is an x86 concept, and this code is in mm/, it would be
>> better to use the name num_poisoned_pages instead of mce_bad_pages.
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Signed-off-by: Borislav Petkov <bp@alien8.de>
> 
> This is not how Signed-of-by: works. You should read
> Documentation/SubmittingPatches (yes, the whole of it) about how that
> whole S-o-b thing works.
> 
> And, FWIW, it should be "Suggested-by: Borislav Petkov <bp@alien8.de>"
> 
> Thanks.
> 

Sorry, I will pay more attention to it next time, thank you. :>

