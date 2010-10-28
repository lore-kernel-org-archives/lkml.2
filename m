Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab0J1Cb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:31:27 -0400
Received: from mail001.aei.ca ([206.123.6.130]:51028 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab0J1CbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:31:25 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 4/7] vmscan: narrowing synchrounous lumply reclaim condition
Date: Wed, 27 Oct 2010 22:31:07 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36-crc+; KDE/4.5.2; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com> <20100805151341.31C3.A69D9226@jp.fujitsu.com> <20101027164138.GD29304@random.random>
In-Reply-To: <20101027164138.GD29304@random.random>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010272231.08978.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 October 2010 12:41:38 Andrea Arcangeli wrote:
> I hope lumpy work stops here and that it goes away whenever THP is
> merged.

Andrea,

I've been running THP here for since May (#25).  Here it does its job as it should.

When do you see it as ready for inclusion?

Thanks
Ed

