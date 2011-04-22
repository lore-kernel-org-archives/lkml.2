Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab1DVQCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:02:24 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60152 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab1DVQCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:02:23 -0400
Subject: Re: [PATCH] mm: Check if any page in a pageblock is reserved
 before marking it MIGRATE_RESERVE
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1303436043-26644-1-git-send-email-john.stultz@linaro.org>
References: <1303436043-26644-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 22 Apr 2011 09:02:10 -0700
Message-ID: <1303488130.9308.5883.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 18:34 -0700, John Stultz wrote:
> This fixes a problem where the first pageblock got marked MIGRATE_RESERVE even
> though it only had a few free pages. This in turn caused no contiguous memory
> to be reserved and frequent kswapd wakeups that emptied the caches to get more
> contiguous memory.

This looks sane to me.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com> 

-- Dave

