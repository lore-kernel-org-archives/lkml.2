Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1CDXMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:12:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1CDXMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:12:43 -0500
Date: Fri, 4 Mar 2011 18:12:41 -0500
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "hch@infradead.org" <hch@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
Message-ID: <20110304231241.GA3507@infradead.org>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
 <20110304040907.GB32404@redhat.com>
 <4D70E78D.9000402@fusionio.com>
 <20110304132551.GA2407@infradead.org>
 <4D70EBB9.302@fusionio.com>
 <20110304140814.GA28953@infradead.org>
 <4D7162B7.20101@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7162B7.20101@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 11:07:51PM +0100, Jens Axboe wrote:
> Seems only gfs2 actually sets the flag now. So how about we remove the
> prio boost for meta data and just retain it as an information attribute?

ext3/4 also use it for inodes and directories.  XFS has code to use, but
it's currently unreachable.
