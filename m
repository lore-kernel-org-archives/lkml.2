Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2GZHob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:44:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60332 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2GZHo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 03:44:29 -0400
Date: Thu, 26 Jul 2012 09:44:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
Message-ID: <20120726074424.GB8421@gmail.com>
References: <20120725203551.GA19762@havoc.gtf.org>
 <20120725204350.GA20530@havoc.gtf.org>
 <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
 <50107297.305@pobox.com>
 <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
 <50107A0D.3060003@pobox.com>
 <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I couldn't find an example of that in a quick look, it's 
> fairly uncommon to have non-conflicting merges that had 
> semantic - but not contextual - conflicts. [...]

This:

  git log --grep='Semantic merge\|Semantic conflict'

gives over a dozen examples of such semantic merges I've done in 
the past 4 years. I fully agree that they are best done in the 
merge commit - in hindsight perhaps with a tad more explanation 
than I did.

Thanks,

	Ingo
