Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2FDSMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:12:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38870 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2FDSL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:11:57 -0400
Date: Mon, 4 Jun 2012 22:11:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>
Subject: Re: Probleam reading fdinfo symlinks after
 30a08bf2d31d275c6fc71dd1811342777e95c831
Message-ID: <20120604181144.GK23701@moon>
References: <20120604151407.GD23701@moon>
 <CA+55aFwWpxvPGT2Gopp=y8_=CAsGoted4sg9_+b8yfkEqjLBYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwWpxvPGT2Gopp=y8_=CAsGoted4sg9_+b8yfkEqjLBYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:59:24AM -0700, Linus Torvalds wrote:
> On Mon, Jun 4, 2012 at 8:14 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> >
> > just tried 3.5-rc1 out and found that with commit
> > 30a08bf2d31d275c6fc71dd1811342777e95c831 the reading
> > of fdinfo files returns "Too many levels of symbolic links"
> > error.
> 
> Ugh. The fdinfo files aren't symlinks at all, and share the revalidate function.
> 
> My bad. The fix isn't pretty, but still better than reverting things.
> This should fix it.

Thanks Linus! This patch fixed it.

Tested-by: Cyrill Gorcunov <gorcunov@openvz.org>
