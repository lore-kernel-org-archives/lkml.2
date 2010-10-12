Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0JLCRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 22:17:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58589 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab0JLCRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 22:17:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Rob Mueller <robm@fastmail.fm>, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1010111907190.27825@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010081255010.32749@router.home> <alpine.DEB.2.00.1010111907190.27825@chino.kir.corp.google.com>
Message-Id: <20101012111451.AD2E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 Oct 2010 11:17:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 8 Oct 2010, Christoph Lameter wrote:
> 
> > It implies that zone reclaim is going to be automatically enabled if the
> > maximum latency to the memory farthest away is 3 times or more that of a
> > local memory access.
> > 
> 
> It doesn't determine what the maximum latency to that memory is, it relies 
> on whatever was defined in the SLIT; the only semantics of that distance 
> comes from the ACPI spec that states those distances are relative to the 
> local distance of 10.

Right. but do we need to consider fake SLIT case? I know actually such bogus
slit are there. but I haven't seen such fake SLIT made serious trouble.



