Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1GXLmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 07:42:45 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34622
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514Ab1GXLmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 07:42:40 -0400
Date: Sun, 24 Jul 2011 07:42:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
Message-ID: <20110724114235.GG26332@infradead.org>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
 <20110723180942.GA1616@x4.trippels.de>
 <4E2B2E88.8080006@redhat.com>
 <20110723203824.GB1652@x4.trippels.de>
 <20110723220212.GA1648@x4.trippels.de>
 <20110724111625.GA12658@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724111625.GA12658@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 07:16:26AM -0400, Christoph Hellwig wrote:
> On Sun, Jul 24, 2011 at 12:02:12AM +0200, Markus Trippelsdorf wrote:
> > The following patch fixes the problem for me:
> 
> Good catch, can you send it with a proper signoff and description?

This also fixes the xfstests 130 regression that popped up in latest
Linus HEAD.  Good to know we have some QA coverage for O_SYNC writes,
althoug I wish it would be more than just one testcase..

