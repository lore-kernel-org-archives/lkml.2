Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2BFMv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:51:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46516 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab2BFMvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:51:55 -0500
MIME-Version: 1.0
In-Reply-To: <op.v87mpive3l0zgt@mpn-glaptop>
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
	<1328271538-14502-13-git-send-email-m.szyprowski@samsung.com>
	<CAJd=RBBPOwftZJUfe3xc6y24=T8un5hPk0wEOT_5v6WMCbDSag@mail.gmail.com>
	<op.v87mpive3l0zgt@mpn-glaptop>
Date: Mon, 6 Feb 2012 20:51:54 +0800
Message-ID: <CAJd=RBCqw=4AEDZU5aPexX2+xVKVhB+uo-ta2hviSAJO63axvw@mail.gmail.com>
Subject: Re: [PATCH 12/15] drivers: add Contiguous Memory Allocator
From: Hillf Danton <dhillf@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/5 Michal Nazarewicz <mina86@mina86.com>:
> On Sun, 05 Feb 2012 05:25:40 +0100, Hillf Danton <dhillf@gmail.com> wrote:
>>
>> Without boot mem reservation, what is the successful rate of CMA to
>> serve requests of 1MiB, 2MiB, 4MiB and 8MiB chunks?
>
>
> CMA will work as long as you manage to get some pageblocks marked as
> MIGRATE_CMA and move all non-movable pages away.  You might try and get it
> done after system has booted but we have not tried nor tested it.

Better to include whatever test results in change log.

And no more questions ;)
