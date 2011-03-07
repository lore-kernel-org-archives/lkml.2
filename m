Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1CGKK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:10:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58246 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab1CGKK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:10:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Mar 2011 19:04:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCHv2 21/24] sys_swapon: remove nr_good_pages variable
Message-Id: <20110307190403.f427738c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1299343345-3984-22-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-22-git-send-email-cesarb@cesarb.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 Mar 2011 13:42:22 -0300
Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> It still exists within setup_swap_map_and_extents(), but after it
> nr_good_pages == p->pages.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

