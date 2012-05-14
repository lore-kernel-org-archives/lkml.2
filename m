Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2ENKqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:46:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51278 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755375Ab2ENKqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:46:09 -0400
Message-ID: <4FB0E26D.9090204@openvz.org>
Date: Mon, 14 May 2012 14:46:05 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm: trivial cleanups in vmscan.c
References: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils> <alpine.LSU.2.00.1205132200150.6148@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1205132200150.6148@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Utter trivia in mm/vmscan.c, mostly just reducing the linecount slightly;
> most exciting change being get_scan_count() calling vmscan_swappiness()
> once instead of twice.
>
> Signed-off-by: Hugh Dickins<hughd@google.com>

Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
