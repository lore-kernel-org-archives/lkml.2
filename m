Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab2I2ALh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:11:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61934 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725Ab2I2ALe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209261929270.8567@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1209191818490.7879@chino.kir.corp.google.com>
	<alpine.LSU.2.00.1209192021270.28543@eggly.anvils>
	<alpine.DEB.2.00.1209261821380.7745@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1209261929270.8567@chino.kir.corp.google.com>
Date: Fri, 28 Sep 2012 17:11:31 -0700
Message-ID: <CANN689Hx2vcQn-DEPAvvJMMQmUrJWOAWnPzeL7maC1SL0okG7A@mail.gmail.com>
Subject: Re: [patch] mm, thp: fix mlock statistics
From: Michel Lespinasse <walken@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 7:29 PM, David Rientjes <rientjes@google.com> wrote:
> NR_MLOCK is only accounted in single page units: there's no logic to
> handle transparent hugepages.  This patch checks the appropriate number
> of pages to adjust the statistics by so that the correct amount of memory
> is reflected.
>
> Reported-by: Hugh Dickens <hughd@google.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Looks good, thanks!

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
