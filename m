Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1E2IgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 04:36:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:51028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1E2IgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 04:36:14 -0400
Subject: Re: [PATCH] mm: fix page_lock_anon_vma leaving mutex locked
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <alpine.LSU.2.00.1105281738530.14374@sister.anvils>
References: <alpine.LSU.2.00.1105281317090.13319@sister.anvils>
	 <1306617270.2497.516.camel@laptop>
	 <alpine.LSU.2.00.1105281437320.13942@sister.anvils>
	 <BANLkTinsq-XJGvRVmBa6kRp0RTj9NqGWtA@mail.gmail.com>
	 <alpine.LSU.2.00.1105281634440.14257@sister.anvils>
	 <BANLkTi=9qqiLNuo9qbcLoQtK3CKSPnhn4g@mail.gmail.com>
	 <alpine.LSU.2.00.1105281738530.14374@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 29 May 2011 10:35:31 +0200
Message-ID: <1306658131.1200.1226.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 17:43 -0700, Hugh Dickins wrote:
> 
> And I'm increasingly confident that it's complete too, but it will be
> interesting to see whether I've persuaded Peter.  It was certainly a
> very good point that he raised, that I hadn't thought of at all. 

Yes you have. And hopefully we've now got enough comments there serve us
next time..
