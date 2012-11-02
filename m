Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2KBIWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 04:22:51 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53791 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2KBIWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 04:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <1351840367-4152-2-git-send-email-minchan@kernel.org>
References: <1351840367-4152-1-git-send-email-minchan@kernel.org>
	<1351840367-4152-2-git-send-email-minchan@kernel.org>
Date: Fri, 2 Nov 2012 10:22:45 +0200
X-Google-Sender-Auth: FjrJxjXhiu5xNsL-JIW1AhcW5hc
Message-ID: <CAOJsxLEHDAj2R13riRY6TkR3sk9=o3mRigT4dQes0FZOcO2KLw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] zsmalloc: promote to lib/
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jens Axboe <axboe@kernel.dk>, gaowanlong@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 9:12 AM, Minchan Kim <minchan@kernel.org> wrote:
> This patch promotes the slab-based zsmalloc memory allocator
> from the staging tree to lib/
>
> zcache/zram depends on this allocator for storing compressed RAM pages
> in an efficient way under system wide memory pressure where
> high-order (greater than 0) page allocation are very likely to
> fail.
>
> For more information on zsmalloc and its internals, read the
> documentation at the top of the zsmalloc.c file.
>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
