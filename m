Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2JHWQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:16:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab2JHWQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:16:41 -0400
Date: Mon, 8 Oct 2012 15:16:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH RFC] mm/swap: automatic tuning for swapin readahead
Message-Id: <20121008151639.bd7f0ec7.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1210081451410.1384@eggly.anvils>
References: <50460CED.6060006@redhat.com>
	<20120906110836.22423.17638.stgit@zurg>
	<alpine.LSU.2.00.1210011418270.2940@eggly.anvils>
	<506AACAC.2010609@openvz.org>
	<alpine.LSU.2.00.1210031337320.1415@eggly.anvils>
	<506DB816.9090107@openvz.org>
	<alpine.LSU.2.00.1210081451410.1384@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012 15:09:58 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> All I want to do right now, is suggest to Andrew that he hold Shaohua's
> patch back from 3.7 for the moment: I'll send a response to Sep 7th's
> mm-commits mail to suggest that - but no great disaster if he ignores me.

Just in the nick of time.

I'll move
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch and
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
into the wait-and-see pile.

