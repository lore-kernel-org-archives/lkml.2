Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2KTAAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:00:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34699 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab2KTAA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:00:28 -0500
Date: Mon, 19 Nov 2012 19:00:26 -0500 (EST)
Message-Id: <20121119.190026.1217383174465455504.davem@davemloft.net>
To: shanwei88@gmail.com
Cc: venkat.x.venkatsubra@oracle.com, rds-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org, htejun@gmail.com
Subject: Re: [PATCH v4 2/9] net: rds: use this_cpu_* per-cpu helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <50A5FB89.4000400@gmail.com>
References: <50A1A7C1.50308@gmail.com>
	<50A5FB89.4000400@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <shanwei88@gmail.com>
Date: Fri, 16 Nov 2012 16:38:33 +0800

> Shan Wei said, at 2012/11/13 9:52:
>> From: Shan Wei <davidshan@tencent.com>
>> 
>> 
>> Signed-off-by: Shan Wei <davidshan@tencent.com>
>> Reviewed-by: Christoph Lameter <cl@linux.com>
> 
> David Miller,  would you like to pick it up to your net-next tree?

Applied.
