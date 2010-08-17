Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab0HQIyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:54:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35133 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab0HQIya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:54:30 -0400
Date: Tue, 17 Aug 2010 04:54:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Joe Perches <joe@perches.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
Subject: Re: [PATCH] fs.h: introduce functions to get/set file->private_data
Message-ID: <20100817085428.GA25330@infradead.org>
References: <201008161137.53187.hartleys@visionengravers.com>
 <20100816231753.GA16546@infradead.org>
 <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
 <1282002601.6518.116.camel@Joe-Laptop>
 <20100817010355.GG21182@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817010355.GG21182@thunk.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 09:03:55PM -0400, Ted Ts'o wrote:
> And spatch could also be used to rename private_data to f_private_data
> if people really cared....

Agreed, that's much better than adding useless accessors.

