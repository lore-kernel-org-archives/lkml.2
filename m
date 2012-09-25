Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2IYX20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:28:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55904 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2IYX2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:28:23 -0400
Date: Tue, 25 Sep 2012 16:28:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Randy Dunlap <rdunlap@xenotime.net>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: mmotm 2012-09-20-17-25 uploaded (fs/bimfmt_elf on uml)
In-Reply-To: <20120926074827.32c7187adef6327c74c75564@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1209251627220.6503@chino.kir.corp.google.com>
References: <20120921002638.7859F100047@wpzn3.hot.corp.google.com> <505C865D.5090802@xenotime.net> <20120922115606.5ca9f599cd88514ddda4831d@canb.auug.org.au> <alpine.DEB.2.00.1209251243320.31518@chino.kir.corp.google.com>
 <20120926074827.32c7187adef6327c74c75564@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012, Stephen Rothwell wrote:

> > This still happens on x86_64 for linux-next as of today's tree.
> 
> Are you sure?  next-20120925?
> 
> $ grep -n vmalloc fs/binfmt_elf.c
> 30:#include <linux/vmalloc.h>
> 1421:	data = vmalloc(size);
> 

Ok, it looks like it's fixed by 1bb6a4c9514e in today's linux-next tree; 
that wasn't present when I pulled it at 2am PDT, so it must be a time zone 
difference.  Thanks.
