Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2KTOMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:12:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2KTOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:12:17 -0500
Date: Tue, 20 Nov 2012 14:12:14 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] balancenuma: fix typo in handling pmd numa fault
Message-ID: <20121120141213.GS8218@suse.de>
References: <CAJd=RBDOAxWeEbjoLvHAt3=P-w1St84oHhfQ5gGox+GoEBF_6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBDOAxWeEbjoLvHAt3=P-w1St84oHhfQ5gGox+GoEBF_6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 01:08:35PM +0800, Hillf Danton wrote:
> s/ptep/pmdp/
> 
> Also a cleanup packed: use haddr directly.
> 
> Btw, will spin if you no longer need the debug trap.
> 

Thanks Hillf. I pulled in 1-3 and patch 5 from this. I left patch 4 for
now as the way it's laid out means it needs to check for the max weight.
It's sortof recovered later by checking if selected_nid != this_nid but
it's doing more work than necessary. I'll re-examine this again but
ideally this particular section would be replaced by something smarter.

-- 
Mel Gorman
SUSE Labs
