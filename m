Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2KTSKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:10:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2KTSKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:10:03 -0500
Date: Tue, 20 Nov 2012 19:09:49 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Recent kernel "mount" slow
Message-ID: <20121120180949.GG1408@quack.suse.cz>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-11-12 08:33:25, Jeff Chua wrote:
> It seems the recent kernel is slower mounting hard disk than older
> kernels. I've not bisect down to exact when this happen as it might
> already been reported or solved. I'm on the latest commit, but it
> doesn't seems to be fixed yet.
> 
> commit 3587b1b097d70c2eb9fee95ea7995d13c05f66e5
> Author: Al Viro <viro@ZenIV.linux.org.uk>
> Date:   Sun Nov 18 19:19:00 2012 +0000
> 
>     fanotify: fix FAN_Q_OVERFLOW case of fanotify_read()
  I haven't heard about such problem so far. What filesystem are you using?
Can you quantify 'is slower'? Bisecting would be welcome of course.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
