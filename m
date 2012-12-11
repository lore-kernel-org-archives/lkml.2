Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2LKNMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:12:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51440 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab2LKNMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:12:41 -0500
Date: Tue, 11 Dec 2012 14:12:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>, WuJianguo <wujianguo@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121211131236.GA4303@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Wanpeng Li <liwanp@linux.vnet.ibm.com>,
	Xishi Qiu <qiuxishi@huawei.com>, WuJianguo <wujianguo@huawei.com>,
	Liujiang <jiang.liu@huawei.com>,
	Simon Jeons <simon.jeons@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <50C72493.3080009@huawei.com>
 <20121211124238.GA9959@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121211124238.GA9959@hacker.(null)>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:42:39PM +0800, Wanpeng Li wrote:
> Futhermore, Andrew didn't like a variable called "mce_bad_pages".
>
> - Why do we have a variable called "mce_bad_pages"? MCE is an x86
> concept, and this code is in mm/. Lights are flashing, bells are
> ringing and a loudspeaker is blaring "layering violation" at us!

Yes, this should simply be called num_poisoned_pages because this is
what this thing counts.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
