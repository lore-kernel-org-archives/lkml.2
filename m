Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0LTCA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:00:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39788 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0LTCAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:00:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Dec 2010 10:55:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 4/5] swap: Remove unnecessary page release
Message-Id: <20101220105507.cb7ebb88.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <7b8f65cb0e08556bdb48c459cb1f72500f6aa61d.1292604746.git.minchan.kim@gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<7b8f65cb0e08556bdb48c459cb1f72500f6aa61d.1292604746.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 02:13:39 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> This patch series changes remove_from_page_cache's page ref counting
> rule. page cache ref count is decreased in remove_from_page_cache.
> So we don't need call again in caller context.
> 
> Cc:Hugh Dickins <hughd@google.com>
> Cc: linux-mm@kvack.org
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

