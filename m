Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0LTJAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:00:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38350 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab0LTJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:00:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Dec 2010 17:54:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC 5/5] truncate: Remove unnecessary page release
Message-Id: <20101220175429.4c469c3d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikn-ZyBKwVaDwuQ=QSvB=wLwY40u8FHGyWccStm@mail.gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<02ab98b3a1450f7a1c31edc48ccc57e887cee900.1292604746.git.minchan.kim@gmail.com>
	<20101220112227.E566.A69D9226@jp.fujitsu.com>
	<20101220112733.064f2fe3.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=UfmZNfKWCisrs6ezzoWqpcwUOT5bs8LGwN7Rv@mail.gmail.com>
	<20101220133526.e075feb8.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikn-ZyBKwVaDwuQ=QSvB=wLwY40u8FHGyWccStm@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 17:09:11 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Because the page is locked and is detached from page cache, I guess
> it's no problem.
> Anyway, I think It's off-topic.
> 

yes.

Thanks,
-Kame

