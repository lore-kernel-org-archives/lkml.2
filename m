Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0HQR66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:58:58 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58917 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0HQR6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:58:53 -0400
Date: Tue, 17 Aug 2010 19:58:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
Subject: Re: [PATCH] fs.h: introduce functions to get/set file->private_data
Message-ID: <20100817175851.GA11463@merkur.ravnborg.org>
References: <201008161137.53187.hartleys@visionengravers.com> <20100816231753.GA16546@infradead.org> <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net> <1282002601.6518.116.camel@Joe-Laptop> <20100817010355.GG21182@thunk.org> <20100817085428.GA25330@infradead.org> <1282065973.24541.106.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282065973.24541.106.camel@Joe-Laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:26:13AM -0700, Joe Perches wrote:
> On Tue, 2010-08-17 at 04:54 -0400, Christoph Hellwig wrote:
> > On Mon, Aug 16, 2010 at 09:03:55PM -0400, Ted Ts'o wrote:
> > > And spatch could also be used to rename private_data to f_private_data
> > > if people really cared....
> > Agreed, that's much better than adding useless accessors.
> 
> Against Linus' current, it's ~850KB.
> Anyone really want it?

This clearly shows how big the effort would be to
introduce access functions.
And if the only gain is grepability then such a
cleanup patch is far more convinient.

It takes minimum effort to create and test, and if you can
get ack from Ted and/or Christoph there is a good chance Linus
would take it right before/after -rc1.

You obviously need to convince him that the patch has
seen decent build testing.

	Sam
