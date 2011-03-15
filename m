Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab1COOMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:12:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab1COOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:12:45 -0400
Date: Tue, 15 Mar 2011 10:12:29 -0400
From: ext Christoph Hellwig <hch@infradead.org>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: ext Christoph Hellwig <hch@infradead.org>, menage@google.com,
        lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] suck some poison out of cgroups' linked lists
Message-ID: <20110315141229.GA12017@infradead.org>
References: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <20110315135137.GA27545@infradead.org>
 <20110315140153.GD18664@esdhcp04044.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315140153.GD18664@esdhcp04044.research.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 04:01:53PM +0200, Phil Carmody wrote:
> > > 2) Ensure that you never leave poison anywhere where you might want
> > > to use list_empty().
> > 
> > The correct way is to use list_del_init() if you want to do list_empty
> > checks later on.
> 
> I.e. (2). Glad I chose that one.

Yes - sorry didn't see the actual patches before.

