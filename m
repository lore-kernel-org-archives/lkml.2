Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2IYTn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:43:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2IYTnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:43:55 -0400
Date: Tue, 25 Sep 2012 12:43:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Randy Dunlap <rdunlap@xenotime.net>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: mmotm 2012-09-20-17-25 uploaded (fs/bimfmt_elf on uml)
In-Reply-To: <20120922115606.5ca9f599cd88514ddda4831d@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1209251243320.31518@chino.kir.corp.google.com>
References: <20120921002638.7859F100047@wpzn3.hot.corp.google.com> <505C865D.5090802@xenotime.net> <20120922115606.5ca9f599cd88514ddda4831d@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2012, Stephen Rothwell wrote:

> > on uml for x86_64 defconfig:
> > 
> > fs/binfmt_elf.c: In function 'fill_files_note':
> > fs/binfmt_elf.c:1419:2: error: implicit declaration of function 'vmalloc'
> > fs/binfmt_elf.c:1419:7: warning: assignment makes pointer from integer without a cast
> > fs/binfmt_elf.c:1437:5: error: implicit declaration of function 'vfree'
> 
> reported in linux-next (offending patch reverted for other
> problems).
> 

This still happens on x86_64 for linux-next as of today's tree.
