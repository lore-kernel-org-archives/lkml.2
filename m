Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1JJLYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:24:45 -0400
Received: from verein.lst.de ([213.95.11.211]:49444 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab1JJLYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:24:44 -0400
Date: Mon, 10 Oct 2011 13:24:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com, viro@zeniv.linux.org.uk, dchinner@redhat.com
Subject: Re: [PATCH v2] ramfs: Remove module leftovers
Message-ID: <20111010112443.GA29093@lst.de>
References: <1318244079-10815-1-git-send-email-richard@nod.at> <20111010110907.GB28672@lst.de> <4E92D352.1030109@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E92D352.1030109@nod.at>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 01:13:22PM +0200, Richard Weinberger wrote:
> > Removing the dead code looks good, but what is the point in using
> > device_initcall?  We've always been using module_init for non-modular
> > code, though.
> > 
> 
> Ah, ok!
> So we can keep the module_init()?
> I was not sure whether it's valid to use module_init() in pure
> non-modular code...

It is valid.  And if it's not the style de jour anymore thousands of people
will flame me now, but I've always done it that way.

