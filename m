Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2KIUMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:12:10 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:46054 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab2KIUMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:12:07 -0500
Date: Fri, 9 Nov 2012 20:12:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: steffen.klassert@secunet.com, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/9] net: xfrm: use __this_cpu_read per-cpu helper
In-Reply-To: <509C688B.5010502@gmail.com>
Message-ID: <0000013ae6ccff86-695eb9f4-23b6-4196-a575-e12d05e1a659-000000@email.amazonses.com>
References: <509C688B.5010502@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Shan Wei wrote:

> v3 fix compile warning:
> net/xfrm/xfrm_ipcomp.c: In function 'ipcomp_alloc_tfms':
> net/xfrm/xfrm_ipcomp.c:285: warning: assignment from incompatible pointer type

Why exactly is the pointer type not compatible? Looks like we have a
problem here.

