Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2KTAA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:00:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34690 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2KTAAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:00:24 -0500
Date: Mon, 19 Nov 2012 19:00:21 -0500 (EST)
Message-Id: <20121119.190021.1729303717477399876.davem@davemloft.net>
To: shanwei88@gmail.com
Cc: timo.teras@iki.fi, steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        htejun@gmail.com
Subject: Re: [PATCH v4 1/9] net: core: use this_cpu_ptr per-cpu helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <50A5FB69.8000907@gmail.com>
References: <50A1A7BA.5000507@gmail.com>
	<50A5FB69.8000907@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <shanwei88@gmail.com>
Date: Fri, 16 Nov 2012 16:38:01 +0800

> Shan Wei said, at 2012/11/13 9:51:
>> From: Shan Wei <davidshan@tencent.com>
>> 
>> flush_tasklet is a struct, not a pointer in percpu var.
>> so use this_cpu_ptr to get the member pointer.
>> 
>> Signed-off-by: Shan Wei <davidshan@tencent.com>
>> Reviewed-by: Christoph Lameter <cl@linux.com>
> 
> David Miller,  would you like to pick it up to your net-next tree?

Applied.
