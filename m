Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0KEJbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 05:31:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:36047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab0KEJa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:30:59 -0400
Date: Fri, 5 Nov 2010 10:30:58 +0100
From: Jan Kara <jack@suse.cz>
To: Peter Bortas <bortas@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Joe Perches <joe@perches.com>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 40/49] fs/udf: Use vzalloc
Message-ID: <20101105093058.GC5033@quack.suse.cz>
References: <cover.1288925424.git.joe@perches.com>
 <a47fec6f62a102773e28984b86f34525fd42b540.1288925425.git.joe@perches.com>
 <20101105091117.GA5033@quack.suse.cz>
 <AANLkTi=gibTo_cC83AV2QmQgh4kDiPsA1taCm4NXztYs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=gibTo_cC83AV2QmQgh4kDiPsA1taCm4NXztYs@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-11-10 10:15:15, Peter Bortas wrote:
> >> -             bitmap = vmalloc(size); /* TODO: get rid of vmalloc */
> >> +             bitmap = vzalloc(size); /* TODO: get rid of vmalloc */
> 
> Shouldn't this comment be removed or at least changed to match the new malloc?
  OK, changed. Thanks for pointing this out.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
