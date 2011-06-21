Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1FUVnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 17:43:07 -0400
Received: from sous-sol.org ([216.99.217.87]:42934 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751613Ab1FUVnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 17:43:04 -0400
Date: Tue, 21 Jun 2011 14:42:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Nai Xia <nai.xia@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V2] ksm: take dirty bit as reference to avoid
 volatile pages scanning
Message-ID: <20110621214233.GN25383@sequoia.sous-sol.org>
References: <201106212055.25400.nai.xia@gmail.com>
 <201106212126.06726.nai.xia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106212126.06726.nai.xia@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nai Xia (nai.xia@gmail.com) wrote:
> This patch makes the page_check_address() can validate if a subpage is
> in its place in a huge page pointed by the address. This can be useful when
> ksm does not split huge pages when looking up the subpages one by one.

Just a quick heads up...this patch does not compile by itself.  Could you
do a little patch cleanup?  Start with just making sure the Subject: is
correct for each patch.  Then make sure the 3 are part of same series.
And finally, make sure each is stand alone and complilable on its own.

thanks,
-chris
