Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2LKDNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:13:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38641 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2LKDNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:13:16 -0500
Message-ID: <1355195591.1933.18.camel@kernel.cn.ibm.com>
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
From: Simon Jeons <simon.jeons@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, wency@cn.fujitsu.com
Date: Mon, 10 Dec 2012 21:13:11 -0600
In-Reply-To: <20121211030125.GY16230@one.firstfloor.org>
References: <50C1AD6D.7010709@huawei.com>
	 <20121207141102.4fda582d.akpm@linux-foundation.org>
	 <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com>
	 <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com>
	 <20121210153805.GS16230@one.firstfloor.org>
	 <1355190540.1933.4.camel@kernel.cn.ibm.com>
	 <20121211020313.GV16230@one.firstfloor.org>
	 <1355192071.1933.7.camel@kernel.cn.ibm.com>
	 <20121211030125.GY16230@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 04:01 +0100, Andi Kleen wrote:
> > Oh, it will be putback to lru list during migration. So does your "some
> > time" mean before call check_new_page?
> 
> Yes until the next check_new_page() whenever that is. If the migration
> works it will be earlier, otherwise later.

But I can't figure out any page reclaim path check if the page is set
PG_hwpoison, can poisoned pages be rclaimed?

			-Simon

> 
> -andi


