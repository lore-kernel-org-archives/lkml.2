Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2LJMLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:11:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39016 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab2LJMLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:11:19 -0500
Date: Mon, 10 Dec 2012 13:11:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, wency@cn.fujitsu.com
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121210121114.GA13631@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Xishi Qiu <qiuxishi@huawei.com>,
	Wanpeng Li <liwanp@linux.vnet.ibm.com>,
	Simon Jeons <simon.jeons@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
	Vyacheslav.Dubeyko@huawei.com, andi@firstfloor.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	wency@cn.fujitsu.com
References: <50C1AD6D.7010709@huawei.com>
 <20121207141102.4fda582d.akpm@linux-foundation.org>
 <20121210083342.GA31670@hacker.(null)>
 <50C5A62A.6030401@huawei.com>
 <1355136423.1700.2.camel@kernel.cn.ibm.com>
 <50C5C4A2.2070002@huawei.com>
 <20121210113923.GA5579@hacker.(null)>
 <50C5CD8D.8060505@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C5CD8D.8060505@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 07:54:53PM +0800, Xishi Qiu wrote:
> One more question, can we add a list_head to manager the poisoned pages?

What would you need that list for? Also, a list is not the most optimal
data structure for when you need to traverse it often.

Thanks.

-- 
Regards/Gruss,
    Boris.
