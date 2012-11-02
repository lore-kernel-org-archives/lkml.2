Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2KBIX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 04:23:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34574 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2KBIXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 04:23:22 -0400
MIME-Version: 1.0
In-Reply-To: <1351840367-4152-4-git-send-email-minchan@kernel.org>
References: <1351840367-4152-1-git-send-email-minchan@kernel.org>
	<1351840367-4152-4-git-send-email-minchan@kernel.org>
Date: Fri, 2 Nov 2012 10:23:21 +0200
X-Google-Sender-Auth: W4PZT8QF9HFntwljzGW5Odb6QjA
Message-ID: <CAOJsxLFfH4R+mVtCgQB2xpRPBZerZLKLq5UNM0k2+2U5YyzRPw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] zram: select ZSMALLOC when ZRAM is configured
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
> At the monent, we can configure zram in driver/block once zsmalloc
> in /lib menu is configured firstly. It's not convenient.
>
> User can configure zram in driver/block regardless of zsmalloc enabling
> by this patch.
>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
