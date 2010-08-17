Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab0HQR0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:26:21 -0400
Received: from mail.perches.com ([173.55.12.10]:1122 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0HQR0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:26:15 -0400
Subject: Re: [PATCH] fs.h: introduce functions to get/set file->private_data
From: Joe Perches <joe@perches.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
In-Reply-To: <20100817085428.GA25330@infradead.org>
References: <201008161137.53187.hartleys@visionengravers.com>
	 <20100816231753.GA16546@infradead.org>
	 <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
	 <1282002601.6518.116.camel@Joe-Laptop> <20100817010355.GG21182@thunk.org>
	 <20100817085428.GA25330@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 10:26:13 -0700
Message-ID: <1282065973.24541.106.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 04:54 -0400, Christoph Hellwig wrote:
> On Mon, Aug 16, 2010 at 09:03:55PM -0400, Ted Ts'o wrote:
> > And spatch could also be used to rename private_data to f_private_data
> > if people really cared....
> Agreed, that's much better than adding useless accessors.

Against Linus' current, it's ~850KB.
Anyone really want it?

$ git diff --shortstat
 495 files changed, 2526 insertions(+), 2529 deletions(-)
$ git diff --stat -p > f_private_data.diff
$ ls -la f_private_data.diff
-rw-r--r-- 1 joe joe 853136 2010-08-17 10:19 f_private_data.diff


