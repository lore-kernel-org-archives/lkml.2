Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2FRSRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:17:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49720 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab2FRSRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:17:06 -0400
Date: Mon, 18 Jun 2012 20:16:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, hnaz@cmpxchg.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 3/6] Fix the x86-64 page colouring code to take pgoff
 into account and use that code as the basis for a generic page colouring
 code.
Message-ID: <20120618181658.GA7190@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
	linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
	peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
	hnaz@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
References: <1340029878-7966-1-git-send-email-riel@redhat.com>
 <1340029878-7966-4-git-send-email-riel@redhat.com>
 <m2k3z48twb.fsf@firstfloor.org>
 <4FDF5B3C.1000007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FDF5B3C.1000007@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 12:45:48PM -0400, Rik van Riel wrote:
> >What tree is that against? I cannot find x86 page colouring code in next
> >or mainline.
> 
> This is against mainline.

Which mainline do you mean exactly?

1/6 doesn't apply ontop of current mainline and by "current" I mean
v3.5-rc3-57-g39a50b42f702.

-- 
Regards/Gruss,
Boris.
