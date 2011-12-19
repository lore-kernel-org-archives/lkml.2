Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1LSTY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:24:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45813 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1LSTYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:24:54 -0500
Message-ID: <4EEF8F85.9010408@gmail.com>
Date: Mon, 19 Dec 2011 14:24:53 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/3] pagemap: export KPF_THP
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/19/11 1:38 PM), Naoya Horiguchi wrote:
> This flag shows that a given pages is a subpage of transparent hugepage.
> It does not care about whether it is a head page or a tail page, because
> it's clear from pfn of the target page which you should know when you read
> /proc/kpageflags.
> 
> Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>

NAK.

The detail of transparent hugepage are hidden by design. We hope it
keep 'transparent'.
Until any explain why we should expose KPF_THP, we don't agree it.

