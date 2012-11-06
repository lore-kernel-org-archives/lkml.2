Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2KFXcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:32:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2KFXcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:32:14 -0500
Date: Tue, 6 Nov 2012 15:32:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@cs.helsinki.fi>,
        gaowanlong@cn.fujitsu.com
Subject: Re: [PATCH v4 0/3] zram/zsmalloc promotion
Message-Id: <20121106153213.03e9cc9f.akpm@linux-foundation.org>
In-Reply-To: <1351840367-4152-1-git-send-email-minchan@kernel.org>
References: <1351840367-4152-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2012 16:12:44 +0900
Minchan Kim <minchan@kernel.org> wrote:

> This patchset promotes zram/zsmalloc from staging.

The changelogs are distressingly short of *reasons* for doing this!

> Both are very clean and zram have been used by many embedded product
> for a long time.

Well that's interesting.

Which embedded products?  How are they using zram and what benefit are
they observing from it, in what scenarios?

