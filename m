Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2CCWko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 17:40:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab2CCWkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 17:40:43 -0500
Date: Sat, 3 Mar 2012 23:40:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: memblock: move mem_hole_size() to .init
In-Reply-To: <20120228200753.GA3252@dhcp-172-17-108-109.mtv.corp.google.com>
Message-ID: <alpine.LNX.2.00.1203032339451.23367@pobox.suse.cz>
References: <alpine.LNX.2.00.1202281614450.31150@pobox.suse.cz> <20120228200753.GA3252@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Tejun Heo wrote:

> > mem_hole_size() is being called only from __init-marked functions, and as 
> > such should be moved to .init section as well. Fixes this warning:
> > 
> > WARNING: vmlinux.o(.text+0x35511): Section mismatch in reference from the function mem_hole_size() to the function .init.text:absent_pages_in_range()
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks. Doesn't seem to have been picked up ... Ingo/hpa, I guess it's 
appropriate for -tip?

-- 
Jiri Kosina
SUSE Labs
