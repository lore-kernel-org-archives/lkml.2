Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2GaMcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:32:20 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51157 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2GaMcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1207301907010.3953@eggly.anvils>
References: <CAJd=RBDQ1J9UTWOK1x6XNYunFz36RsMnr1Om9HsQQ_Kp8P7RKQ@mail.gmail.com>
	<alpine.LSU.2.00.1207301907010.3953@eggly.anvils>
Date: Tue, 31 Jul 2012 20:32:18 +0800
Message-ID: <CAJd=RBBe2XHwe7T+EKoomFq1t2Me+VbJkz92Ow15FjEsPLJUow@mail.gmail.com>
Subject: Re: [RFC patch] vm: clear swap entry before copying pte
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Tue, Jul 31, 2012 at 10:34 AM, Hugh Dickins <hughd@google.com> wrote:
> But I can see that the lack of reinitialization of entry.val here
> does raise doubt and confusion.  A better tidyup would be to remove
> the initialization of swp_entry_t entry from its onstack declaration,
> and do it at the again label instead.


I just want to avoid allocating page in add_swap_count_continuation()
for non clear reason, as you see, which is not a bug fix.

Thanks,
		Hillf
