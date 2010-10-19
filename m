Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0JSRGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:06:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:39863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab0JSRGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:06:53 -0400
Subject: Re: [patch 07/35] fs: icache lock i_state
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <E1P89jV-0006B6-Go@pomaz-ex.szeredi.hu>
References: <20101019034216.319085068@kernel.dk>
	 <20101019034656.201381145@kernel.dk>
	 <E1P89jV-0006B6-Go@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 19:06:49 +0200
Message-ID: <1287508009.1998.3442.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 12:47 +0200, Miklos Szeredi wrote:
> On Tue, 19 Oct 2010, npiggin@kernel.d wrote:
> > Index: linux-2.6/fs/fs-writeback.c
> > ===================================================================
> > --- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:58.000000000 +1100
> > +++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:36.000000000 +1100
> > @@ -288,10 +288,12 @@
> 
> The function name here helps review a bit.  If you are using quilt add
> "export QUILT_DIFF_OPTS=-p" to .quiltrc.

I have:

QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"

in my /etc/quilt.quiltrc, it is similar to --show-c-function but doesn't
consider labels.
