Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0JEQFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:05:14 -0400
Received: from canuck.infradead.org ([134.117.69.58]:52932 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab0JEQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:05:13 -0400
X-Greylist: delayed 1744 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 12:05:13 EDT
Date: Tue, 5 Oct 2010 11:36:04 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        hch@infradead.org, lnxninja@linux.vnet.ibm.com, axboe@kernel.dk,
        pbadari@us.ibm.com, Yuri L Volobuev <volobuev@us.ibm.com>
Subject: Re: [RFC][PATCH] try not to let dirty inodes fester
Message-ID: <20101005153604.GA25228@lst.de>
References: <20101001191449.0AA0E233@kernel.beaverton.ibm.com>
 <20101002113238.GF4681@dastard>
 <1286292345.9970.4231.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286292345.9970.4231.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 08:25:45AM -0700, Dave Hansen wrote:
> It's GPFS, which is a binary blob to me, unfortunately.

Let them fix their junk themselves then.  I'm rather annoyed that you
actually are brave enough to annoy us with dealing with this.  Seriously,
if just about IBMer is now a GPFS henchman in disguise I might as well
stop helping IBM at all.  And in FS land it really looks like that recently.

What about contributing to the in-kernel cluster filesystems instead of
making our lives a pain for your personal gain?

