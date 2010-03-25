Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0CYLWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:22:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40902 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab0CYLWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:22:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 10/11] Direct compact when a high-order allocation fails
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100319101016.GS12388@csn.ul.ie>
References: <20100319152516.8778.A69D9226@jp.fujitsu.com> <20100319101016.GS12388@csn.ul.ie>
Message-Id: <20100325202145.6C92.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Mar 2010 20:22:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Viewpoint 5. end user surprising
> > 
> > lumpy reclaim can makes swap-out even though the system have lots free
> > memory. end users very surprised it and they can think it is bug.
> > 
> > Also, this swap activity easyly confuse that an administrator decide when
> > install more memory into the system.
> > 
> 
> Compaction in this case is a lot less surprising. If there is enough free
> memory, compaction will trigger automatically without any reclaim.

I fully agree this.


