Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1KQJyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:54:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab1KQJyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:54:20 -0500
Date: Thu, 17 Nov 2011 10:54:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: Wang Sheng-Hui <shhuiw@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: cleanup the comment for head/tail pages of compound
 pages in mm/page_alloc.c
In-Reply-To: <20111117082148.GA30544@tiehlicka.suse.cz>
Message-ID: <alpine.LNX.2.00.1111171054050.15187@pobox.suse.cz>
References: <4EC21D78.4080508@gmail.com> <20111115132409.GA7551@tiehlicka.suse.cz> <4EC2FE33.7030905@gmail.com> <20111117082148.GA30544@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Michal Hocko wrote:

> [CCing trivial tree]
> 
> Unquoted patch at https://lkml.org/lkml/2011/11/15/402
> 
> On Wed 16-11-11 08:05:07, Wang Sheng-Hui wrote:
> [...]
> > Thanks, Michal.
> > 
> > New patch generated.
> > 
> > 
> > [PATCH] mm: cleanup the comment for head/tail pages of compound pages in mm/page_alloc.c
> > 
> > Only tail pages point at the head page using their ->first_page fields.
> > 
> > Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
