Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2IJVkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:40:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51257 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab2IJVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:40:09 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209071558430.28027@chino.kir.corp.google.com>
References: <50484E2C.1060107@gmail.com>
	<alpine.DEB.2.00.1209071558430.28027@chino.kir.corp.google.com>
Date: Mon, 10 Sep 2012 14:40:09 -0700
Message-ID: <CA+8MBb+z27j7KNRhnVobgVU=ckSkSyuC7f=M7oNv=_2Oe5ovYA@mail.gmail.com>
Subject: Re: [PATCH RESEND]mm/ia64: fix a node distance bug
From: Tony Luck <tony.luck@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: wujianguo <wujianguo106@gmail.com>, akpm@linux-foundation.org,
        fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jiang.liu@huawei.com,
        guohanjun@huawei.com, qiuxishi@huawei.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 3:58 PM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 6 Sep 2012, wujianguo wrote:
>> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>
> Acked-by: David Rientjes <rientjes@google.com>

Applied (should show up in linux-next in the next day or two).

-Tony
