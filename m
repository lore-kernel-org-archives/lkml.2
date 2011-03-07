Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1CGGNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 01:13:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36482 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1CGGNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 01:13:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Mar 2011 15:07:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove inline from scan_swap_map
Message-Id: <20110307150721.16ff00e8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
References: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 Mar 2011 15:49:16 -0300
Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> scan_swap_map is a large function (224 lines), with several loops and a
> complex control flow involving several gotos.
> 
> Given all that, it is a bit silly that is is marked as inline. The
> compiler agrees with me: on a x86-64 compile, it did not inline the
> function.
> 
> Remove the "inline" and let the compiler decide instead.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

