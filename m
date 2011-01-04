Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1ADFym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:54:42 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:21614 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab1ADFyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:54:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8GAEBFIk15Ldpx/2dsb2JhbACWGY4cdLtOhUoEljY
Date: Tue, 4 Jan 2011 16:54:37 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Valdis.Kletnieks@vt.edu
Cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fs@vger.kernel.org
Subject: Re: 2.6.37-next problems with fs dcache patches.
Message-ID: <20110104055437.GB3402@amd>
References: <19902.1293047238@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19902.1293047238@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 02:47:18PM -0500, Valdis.Kletnieks@vt.edu wrote:
> And we end with:
> 
> git bisect skip
> There are only 'skip'ped commits left to test.
> The first bad commit could be any of:
> 1f42f4566770e4d7bda4be9bfc0f39a237685f54
> 40f9b00323a73859ac53d7d4f2f820c4c8d33165
> 27056795db2de7bfefc5ea5cbc4486ba8f3fe90d
> ff7f5c4c2c1542cd8a8c538b11441aac47d87709
> 3c884da2830985495ddbc8817871070cb6e9d86d
> c06020c90ab49382419e71f87ed341d28f87a166
> 0c259f9c9ee263a5d907030e29c52fd8d206c631
> We cannot bisect more!
> 
> Any ideas?  Patches that weren't in linux-next as of 12-17?

Hi, sorry for the late reply. I should have since fixed up the
bisectability errors (including this one) in the tree. Please
report if there are any more, and apologes for messing up your
testing.

Thanks,
Nick


