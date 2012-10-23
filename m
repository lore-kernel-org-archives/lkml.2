Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab2JWNCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:02:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49469
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756999Ab2JWNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:02:40 -0400
Date: Tue, 23 Oct 2012 09:02:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/21] ocfs2: drop vmtruncate
Message-ID: <20121023130237.GA21594@infradead.org>
References: <508296B4.60508@gmail.com>
 <20121023085448.GM5635@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023085448.GM5635@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:54:48AM -0700, Joel Becker wrote:
> On Sat, Oct 20, 2012 at 02:19:00PM +0200, Marco Stornelli wrote:
> > Removed vmtruncate
> > 
> > Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Acked-by: Joel Becker <jlbec@evilplan.org>
> 
> Do you want me to pull this, or are you going to send it with your set?

Is this really correct?  It now updates i_size before starting a
transaction.

