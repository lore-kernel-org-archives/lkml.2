Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0HQB6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 21:58:54 -0400
Received: from mail.perches.com ([173.55.12.10]:1109 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab0HQB6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 21:58:53 -0400
Subject: Re: [PATCH] fs.h: introduce functions to get/set file->private_data
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
In-Reply-To: <20100817010355.GG21182@thunk.org>
References: <201008161137.53187.hartleys@visionengravers.com>
	 <20100816231753.GA16546@infradead.org>
	 <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
	 <1282002601.6518.116.camel@Joe-Laptop>  <20100817010355.GG21182@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 18:58:49 -0700
Message-ID: <1282010329.24541.71.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 21:03 -0400, Ted Ts'o wrote:
> And spatch could also be used to rename private_data to f_private_data
> if people really cared....

In struct file, private_data is the only member not prefixed with f_.

It's a small .cocci file, but treewide, it's a relatively big patch.


