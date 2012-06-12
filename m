Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2FLQD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:03:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47526 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2FLQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <4FD6ECE2.6070901@kernel.org>
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org>
 <1338575387-26972-4-git-send-email-john.stultz@linaro.org>
 <4FC9235F.5000402@gmail.com> <4FC92E30.4000906@linaro.org>
 <4FC9360B.4020401@gmail.com> <4FC937AD.8040201@linaro.org>
 <4FC9438B.1000403@gmail.com> <4FC94F61.20305@linaro.org> <4FCFB4F6.6070308@gmail.com>
 <4FCFEE36.3010902@linaro.org> <CAO6Zf6D++8hOz19BmUwQ8iwbQknQRNsF4npP4r-830j04vbj=g@mail.gmail.com>
 <4FD13C30.2030401@linux.vnet.ibm.com> <4FD16B6E.8000307@linaro.org>
 <4FD1848B.7040102@gmail.com> <4FD2C6C5.1070900@linaro.org> <4FD6ECE2.6070901@kernel.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 12 Jun 2012 12:03:04 -0400
Message-ID: <CAHGf_=oTC6LGd-5=aGYM4rj+3AAVPr9Zk8cT_FXguVhSVgKWnQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
To: Minchan Kim <minchan@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Off-topic:
> But I'm not sure because I might try to make new easy-reclaimable LRU list for low memory notification.
> That LRU list would contain non-mapped clean cache page and volatile pages if I decide adding it.
> Both pages has a common characteristic that recreating page is less costly.
> It's true for eMMC/SSD like device, at least.

+1.

I like L2 inactive list.
