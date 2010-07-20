Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0GTPU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:20:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab0GTPU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:20:28 -0400
Date: Tue, 20 Jul 2010 17:20:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 27/36] fs/ocfs2: Remove unnecessary casts of
 private_data
In-Reply-To: <20100712223731.GH12179@mail.oracle.com>
Message-ID: <alpine.LNX.2.00.1007201720100.4741@pobox.suse.cz>
References: <cover.1278967120.git.joe@perches.com> <c75b92bbfb63964703ae99733f39696af4550f07.1278967121.git.joe@perches.com> <20100712223731.GH12179@mail.oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Joel Becker wrote:

> On Mon, Jul 12, 2010 at 01:50:19PM -0700, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  fs/ocfs2/dlm/dlmdebug.c |    6 +++---
> >  fs/ocfs2/dlmfs/dlmfs.c  |    3 +--
> >  fs/ocfs2/dlmglue.c      |    4 ++--
> >  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> Acked-by: Joel Becker <joel.becker@oracle.com>

As this change is not present in linux-next as of today, I have applied 
it. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
