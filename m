Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab0HQSVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:21:24 -0400
Received: from mail.perches.com ([173.55.12.10]:1130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095Ab0HQSVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:21:19 -0400
Subject: Re: [PATCH] fs.h: introduce functions to get/set file->private_data
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
In-Reply-To: <20100817175851.GA11463@merkur.ravnborg.org>
References: <201008161137.53187.hartleys@visionengravers.com>
	 <20100816231753.GA16546@infradead.org>
	 <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
	 <1282002601.6518.116.camel@Joe-Laptop> <20100817010355.GG21182@thunk.org>
	 <20100817085428.GA25330@infradead.org>
	 <1282065973.24541.106.camel@Joe-Laptop>
	 <20100817175851.GA11463@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:21:17 -0700
Message-ID: <1282069277.14975.21.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 19:58 +0200, Sam Ravnborg wrote:
> On Tue, Aug 17, 2010 at 10:26:13AM -0700, Joe Perches wrote:
> > On Tue, 2010-08-17 at 04:54 -0400, Christoph Hellwig wrote:
> > > On Mon, Aug 16, 2010 at 09:03:55PM -0400, Ted Ts'o wrote:
> > > > And spatch could also be used to rename private_data to f_private_data
> > > > if people really cared....
> > > Agreed, that's much better than adding useless accessors.
> > Against Linus' current, it's ~850KB.
> > Anyone really want it?
> a cleanup patch is far more convinient.
> It takes minimum effort to create and test, and if you can
> get ack from Ted and/or Christoph there is a good chance Linus
> would take it right before/after -rc1.
> You obviously need to convince him that the patch has
> seen decent build testing.

I don't have the passel of cross compilers,
so someone else would need to do that.

I compiled it 32 bit x86 allyesconfig only.


