Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab2JYARk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:17:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40176 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858Ab2JYARi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:17:38 -0400
Date: Wed, 24 Oct 2012 17:17:32 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/21] ocfs2: drop vmtruncate
Message-ID: <20121025001731.GB3140@localhost>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <508296B4.60508@gmail.com>
 <20121023085448.GM5635@localhost>
 <20121023130237.GA21594@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023130237.GA21594@infradead.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 09:02:38AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 23, 2012 at 01:54:48AM -0700, Joel Becker wrote:
> > On Sat, Oct 20, 2012 at 02:19:00PM +0200, Marco Stornelli wrote:
> > > Removed vmtruncate
> > > 
> > > Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> > 
> > Acked-by: Joel Becker <jlbec@evilplan.org>
> > 
> > Do you want me to pull this, or are you going to send it with your set?
> 
> Is this really correct?  It now updates i_size before starting a
> transaction.

	Ok, I missed that, and I need to re-check.

Joel

-- 

"If at first you don't succeed, cover all traces that you tried."
                                                        -Unknown

			http://www.jlbec.org/
			jlbec@evilplan.org
