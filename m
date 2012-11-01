Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab2KAJBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:01:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59085 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab2KAJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:01:03 -0400
Message-ID: <50923A48.1080906@gmail.com>
Date: Thu, 01 Nov 2012 17:00:56 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Christoph Lameter <cl@linux.com>, steffen.klassert@secunet.com,
        David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] net: xfrm: use this_cpu_ptr per-cpu helper
References: <509109F9.3030904@gmail.com> <0000013ab7e4a640-60bd5b38-a1fc-4730-b918-4109211ffea0-000000@email.amazonses.com> <20121101034136.GA27343@gondor.apana.org.au>
In-Reply-To: <20121101034136.GA27343@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu said, at 2012/11/1 11:41:
> Please refer to the comment in the patch above.
> 
> But I think the patch is wrong anyway because it would introduce
> a warning, no?

yes, __this_cpu_ptr(or __this_cpu_read) is more reasonable 
which don't check preemption context.

> 
> Thanks,
> 

