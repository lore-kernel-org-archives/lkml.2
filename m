Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1IPFtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 01:49:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab1IPFtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 01:49:39 -0400
Date: Fri, 16 Sep 2011 07:49:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Temporary location for hid, apm and trivial trees
In-Reply-To: <20110916111939.98b49c7304550ae509e1435f@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1109160748000.13109@pobox.suse.cz>
References: <alpine.LNX.2.00.1109141520450.13109@pobox.suse.cz> <20110915000759.44ec63c0f9a3d68239886de5@canb.auug.org.au> <alpine.LNX.2.00.1109141650280.13109@pobox.suse.cz> <20110915005647.31daf133c37610bfa1694a8e@canb.auug.org.au>
 <20110916111939.98b49c7304550ae509e1435f@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011, Stephen Rothwell wrote:

> > > Ah, you are right, it has been broken. Fixed now.
> > 
> > Excellent, thanks.
> 
> Today (and yesterday) I am getting:
> 
> twin.jikos.cz[0: 89.185.236.188]: errno=Connection refused
> 
> I will kepp using what I have fetched already.

Gah, that git daemon thing died. I have now put a slightly newer version 
in place and be monitoring it more closely.

Thanks for reportig,

-- 
Jiri Kosina
SUSE Labs
