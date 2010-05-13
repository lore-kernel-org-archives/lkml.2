Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab0EMIG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 04:06:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57838 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab0EMIGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 04:06:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: ngupta@vflare.org
Subject: Re: [PATCH] Cleanup migrate case in try_to_unmap_one
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <4BEBA70C.9050404@vflare.org>
References: <20100513144336.216D.A69D9226@jp.fujitsu.com> <4BEBA70C.9050404@vflare.org>
Message-Id: <20100513163441.2176.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 13 May 2010 17:06:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/13/2010 11:34 AM, KOSAKI Motohiro wrote:
> >> Remove duplicate handling of TTU_MIGRATE case for
> >> anonymous and filesystem pages.
> >>
> >> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> > 
> > This patch change swap cache case. I think this is not intentional.
> 
> IIUC, we never call this function with TTU_MIGRATE for swap cache pages.
> So, the behavior after this patch remains unchanged.

Why?

