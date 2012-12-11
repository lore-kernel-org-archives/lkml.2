Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab2LKC67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:58:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43615 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2LKC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:58:58 -0500
Date: Tue, 11 Dec 2012 03:58:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Andi Kleen <andi@firstfloor.org>,
        Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, wency@cn.fujitsu.com,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121211025857.GX16230@one.firstfloor.org>
References: <50C1AD6D.7010709@huawei.com> <20121207141102.4fda582d.akpm@linux-foundation.org> <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com> <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com> <20121210153805.GS16230@one.firstfloor.org> <50C6997C.1080702@huawei.com> <20121211024522.GA10505@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211024522.GA10505@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That sounds like overkill. There are not so many free pages in a
> typical server system.

As Fengguang said -- memory error handling is tricky. Lots of things
could be done in theory, but they all have a cost in testing and 
maintenance. 

In general they are only worth doing if the situation is common and
represents a significant percentage of the total pages of a relevant server
workload.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
