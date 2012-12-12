Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2LLKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:25:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57290 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab2LLKZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:25:27 -0500
Date: Wed, 12 Dec 2012 11:25:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 3/3] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121212102523.GA8760@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Xishi Qiu <qiuxishi@huawei.com>, WuJianguo <wujianguo@huawei.com>,
	Liujiang <jiang.liu@huawei.com>,
	Simon Jeons <simon.jeons@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <50C7FB85.8040008@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C7FB85.8040008@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 11:35:33AM +0800, Xishi Qiu wrote:
> Since MCE is an x86 concept, and this code is in mm/, it would be
> better to use the name num_poisoned_pages instead of mce_bad_pages.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Signed-off-by: Borislav Petkov <bp@alien8.de>

This is not how Signed-of-by: works. You should read
Documentation/SubmittingPatches (yes, the whole of it) about how that
whole S-o-b thing works.

And, FWIW, it should be "Suggested-by: Borislav Petkov <bp@alien8.de>"

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
