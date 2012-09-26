Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2IZRGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:06:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58317 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab2IZRGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLGjp5PAgPe3KSvMfqJEyVC4YHeP+FW3AmnCorpHqnfang@mail.gmail.com>
References: <1348649419-16494-1-git-send-email-minchan@kernel.org>
	<1348649419-16494-2-git-send-email-minchan@kernel.org>
	<CAOJsxLGjp5PAgPe3KSvMfqJEyVC4YHeP+FW3AmnCorpHqnfang@mail.gmail.com>
Date: Wed, 26 Sep 2012 10:06:12 -0700
Message-ID: <CAPkvG_eB84ELG_r_dVGvS+G7i21+8wqXon8a1Hfgctqsf4=BKw@mail.gmail.com>
Subject: Re: [PATCH 1/3] zsmalloc: promote to lib/
From: Nitin Gupta <ngupta@vflare.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/26 Pekka Enberg <penberg@kernel.org>:
> On Wed, Sep 26, 2012 at 11:50 AM, Minchan Kim <minchan@kernel.org> wrote:
>>  lib/Kconfig                              |    2 +
>>  lib/Makefile                             |    1 +
>>  lib/zsmalloc/Kconfig                     |   18 +
>>  lib/zsmalloc/Makefile                    |    1 +
>>  lib/zsmalloc/zsmalloc.c                  | 1064 ++++++++++++++++++++++++++++++
>
> What's wrong with mm/zsmalloc.c?

I think mm/ directory should only contain the code which is intended
for global use such as the slab allocator, page reclaim code etc.
zsmalloc is used by only one (or possibly two) drivers, so lib/ seems
to be the right place.

Thanks,
Nitin
