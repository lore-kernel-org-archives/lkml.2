Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0JPQ3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:29:06 -0400
Received: from canuck.infradead.org ([134.117.69.58]:37844 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0JPQ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:29:05 -0400
Date: Sat, 16 Oct 2010 12:29:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] exofs: use iput() for inode reference count
 decrements
Message-ID: <20101016162904.GB20086@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-8-git-send-email-david@fromorbit.com>
 <20101016075650.GM19147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016075650.GM19147@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 06:56:50PM +1100, Nick Piggin wrote:
> On Fri, Oct 08, 2010 at 04:21:21PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Direct modification of the inode reference count is a no-no. Convert
> > the exofs decrements to call iput() instead of acting directly on
> > i_count.
> 
> Could this go to exofs maintainer and get merged as a bugfix?

I already pinged Boaz.

