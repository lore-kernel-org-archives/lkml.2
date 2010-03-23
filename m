Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0CWWpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:45:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33630 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0CWWpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=srEwaROMnvWAQMwII1a7KnRLd0M8Hgqvvk7AUNL/1+OutIenX+yqpV9UjrOVzulee/
         59T/O6GOpax5YccJrEYQazri4P+cUTzcWROFKWHcUztOi7tWuVPf11/bUvIprDRj1QOr
         0McmYGnXPXSBxmnVF4ypwfuW9BTx43/CtQRE8=
MIME-Version: 1.0
In-Reply-To: <1269347146-7461-10-git-send-email-mel@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	 <1269347146-7461-10-git-send-email-mel@csn.ul.ie>
Date: Wed, 24 Mar 2010 07:45:20 +0900
Message-ID: <28c262361003231545i78104ccfr14b68f50dc85bfc2@mail.gmail.com>
Subject: Re: [PATCH 09/11] Add /sys trigger for per-node memory compaction
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 9:25 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> This patch adds a per-node sysfs file called compact. When the file is
> written to, each zone in that node is compacted. The intention that this
> would be used by something like a job scheduler in a batch system before
> a job starts so that the job can allocate the maximum number of
> hugepages without significant start-up cost.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
