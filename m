Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab2IDX3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:29:01 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:53570 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab2IDX26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:28:58 -0400
Date: Tue, 4 Sep 2012 16:28:58 -0700
From: Zach Brown <zab@zabbo.net>
To: Jan Kara <jack@suse.cz>
Cc: Li Wang <liwang@nudt.edu.cn>, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] VFS: File System Mount Wide O_DIRECT Support
Message-ID: <20120904232858.GB11953@lenny.home.zabbo.net>
References: <000001cd8a86$89df83b0$9d9e8b10$@edu.cn>
 <20120904122743.GA8656@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904122743.GA8656@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The idea is simple, leave the desicion for the file system user to enable file system mount 
> > wide O_DIRECT support with a new mount option, for example,

>   I believe a better approach to your problem is actually to enable
> loopback device driver to use direct IO. Someone was actually working on
> this but I'm not sure where this ended up.

Dave's been working on getting those patches merged.  I'm also not sure
where the work currently is, but here's an older posting:

  http://lwn.net/Articles/489647/

- z
