Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab0DGAHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:07:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932211Ab0DGAGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:06:45 -0400
Date: Tue, 6 Apr 2010 17:05:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 10/14] Add /sys trigger for per-node memory compaction
Message-Id: <20100406170559.52093bd5.akpm@linux-foundation.org>
In-Reply-To: <1270224168-14775-11-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-11-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Apr 2010 17:02:44 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> This patch adds a per-node sysfs file called compact. When the file is
> written to, each zone in that node is compacted. The intention that this
> would be used by something like a job scheduler in a batch system before
> a job starts so that the job can allocate the maximum number of
> hugepages without significant start-up cost.

Would it make more sense if this was a per-memcg thing rather than a
per-node thing?

