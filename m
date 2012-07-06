Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2GFD7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:59:04 -0400
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:33263 "HELO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754778Ab2GFD7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120706123555.949d8efb4de5c4df18fb1ec0@canb.auug.org.au>
References: <20120706123555.949d8efb4de5c4df18fb1ec0@canb.auug.org.au>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 5 Jul 2012 20:58:38 -0700
X-Google-Sender-Auth: lSnxdtj-s0UIWqfBwUzyvyu8oac
Message-ID: <CAL1RGDW+3Q86QUp-aaWajT8nLK_7hQuCbxeE4q9He=aGdAMX6Q@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 7:35 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> drivers/infiniband/core/cma.c: In function 'rdma_bind_addr':
> drivers/infiniband/core/cma.c:2411:30: error: 'struct net' has no member named 'ipv6'

Thanks, fixed with a "#if IS_ENABLED(CONFIG_IPV6)" around the code
that touches ipv6... Sean, let me know if more is required.
