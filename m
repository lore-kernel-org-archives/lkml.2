Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0CQCnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:43:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56946 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab0CQCm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:42:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 05/11] Export unusable free space index via /proc/unusable_index
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1268412087-13536-6-git-send-email-mel@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie> <1268412087-13536-6-git-send-email-mel@csn.ul.ie>
Message-Id: <20100317114126.4C97.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Mar 2010 11:42:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unusable free space index is a measure of external fragmentation that
> takes the allocation size into account. For the most part, the huge page
> size will be the size of interest but not necessarily so it is exported
> on a per-order and per-zone basis via /proc/unusable_index.
> 
> The index is a value between 0 and 1. It can be expressed as a
> percentage by multiplying by 100 as documented in
> Documentation/filesystems/proc.txt.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Acked-by: Rik van Riel <riel@redhat.com>

thanks.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



