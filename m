Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2IZJvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:51:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39986 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2IZJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:51:50 -0400
MIME-Version: 1.0
In-Reply-To: <1348649419-16494-2-git-send-email-minchan@kernel.org>
References: <1348649419-16494-1-git-send-email-minchan@kernel.org>
	<1348649419-16494-2-git-send-email-minchan@kernel.org>
Date: Wed, 26 Sep 2012 12:51:49 +0300
X-Google-Sender-Auth: qwSiwYxaHDWAOy93THVhjKyzqx8
Message-ID: <CAOJsxLGjp5PAgPe3KSvMfqJEyVC4YHeP+FW3AmnCorpHqnfang@mail.gmail.com>
Subject: Re: [PATCH 1/3] zsmalloc: promote to lib/
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:50 AM, Minchan Kim <minchan@kernel.org> wrote:
>  lib/Kconfig                              |    2 +
>  lib/Makefile                             |    1 +
>  lib/zsmalloc/Kconfig                     |   18 +
>  lib/zsmalloc/Makefile                    |    1 +
>  lib/zsmalloc/zsmalloc.c                  | 1064 ++++++++++++++++++++++++++++++

What's wrong with mm/zsmalloc.c?
