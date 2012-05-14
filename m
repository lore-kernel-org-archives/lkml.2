Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2ENF4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:56:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34786 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2ENF4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1205132200150.6148@eggly.anvils>
References: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils> <alpine.LSU.2.00.1205132200150.6148@eggly.anvils>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 14 May 2012 01:56:20 -0400
Message-ID: <CAHGf_=rr9ATkYBnwas7BSfPpD=cCf1jotguOdR1ysBnWznJ-GA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: trivial cleanups in vmscan.c
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 1:01 AM, Hugh Dickins <hughd@google.com> wrote:
> Utter trivia in mm/vmscan.c, mostly just reducing the linecount slightly;
> most exciting change being get_scan_count() calling vmscan_swappiness()
> once instead of twice.
>
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
