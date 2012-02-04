Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2BDJ7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 04:59:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2BDJ7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 04:59:39 -0500
Date: Sat, 4 Feb 2012 10:59:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [Patch] resource: move EXPORT_SYMBOL right after definition
In-Reply-To: <4F2CD9DB.70501@gmail.com>
Message-ID: <alpine.LNX.2.00.1202041059180.25026@pobox.suse.cz>
References: <1328276573-15265-1-git-send-email-xiyou.wangcong@gmail.com> <4F2C088E.3090106@windriver.com> <4F2CD9DB.70501@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Feb 2012, Cong Wang wrote:

> > > EXPORT_SYMBOL(adjust_resource) should be right after adjust_resource().
> > 
> > Presumably this is to get rid of a checkpatch warning?
> > Maybe it makes sense to have it go via the trivial tree?
> > 
> 
> Yeah, although I found this by code review, I agree this is proper for
> trivial.

I have already applied it yesterday.

-- 
Jiri Kosina
SUSE Labs
