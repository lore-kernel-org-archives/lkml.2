Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab2GMMKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:10:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611Ab2GMMKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:10:12 -0400
Date: Fri, 13 Jul 2012 14:10:09 +0200
From: Jan Kara <jack@suse.cz>
To: Mathias Krause <minipli@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix info leaks on export for udf and isofs
Message-ID: <20120713121009.GA20361@quack.suse.cz>
References: <1342075615-24683-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342075615-24683-1-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-07-12 08:46:53, Mathias Krause wrote:
> Al, Jan,
> 
> this patch set fixes info leaks in isofs and udf. Both file systems fail to
> initialize all bytes of the f_handle byte array when creating a handle for a
> path pointing to a directory. This memory gets copied to userland and that for
> is a leak of uninitialized heap data to userland that should be fixed.
> 
> This info leak can be triggered locally by using the name_to_handle_at()
> syscall.
  Thanks! I've merged both patches into my tree.

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
