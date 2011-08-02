Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1HBD7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 23:59:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1HBD65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 23:58:57 -0400
Date: Tue, 2 Aug 2011 11:59:14 +0800
From: Han Pingtian <phan@redhat.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: [BUG] perf kmem: Processed 0 events and LOST 75691!
Message-ID: <20110802035914.GA6626@hpt.nay.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I got this with 3.0 perf, but the running kernel is a old one:

[root@hp-dl580g7-01 perf]# ./perf kmem record sleep 1
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 21.789 MB perf.data (~951977 samples)
]
Processed 0 events and LOST 76148!

Check IO/CPU overload!

[root@hp-dl580g7-01 perf]# ./perf kmem stat
Processed 0 events and LOST 76148!

Check IO/CPU overload!


SUMMARY
=======
Total bytes requested: 5725028
Total bytes allocated: 6291512
Total bytes wasted on internal fragmentation: 566484
Internal fragmentation: 9.003941%
Cross CPU allocations: 28/84295

Is this a bug?

Thanks.

-- 
Han Pingtian
Quality Engineer
hpt @ #kernel-qe
Red Hat, Inc
Freedom ... courage ... Commitment ... ACCOUNTABILITY
