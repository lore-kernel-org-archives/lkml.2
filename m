Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3ACUYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 15:24:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55539 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3ACUYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 15:24:11 -0500
Date: Thu, 3 Jan 2013 20:24:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] vfs: Add missing errno.h inclusion to namei.h
Message-ID: <20130103202405.GD4939@ZenIV.linux.org.uk>
References: <1357133786-29587-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20130102084205.2320f6b9@tlielax.poochiereds.net>
 <20130102134606.GE4627@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102134606.GE4627@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 01:46:07PM +0000, Mark Brown wrote:
> On Wed, Jan 02, 2013 at 08:42:05AM -0500, Jeff Layton wrote:
> 
> > I think Ted and Stephen (cc'ed here) proposed the same patch a week or
> > so ago, but I'm not sure why Al hasn't pushed it yet.
> 
> Well, a Christmas vacation isn't totally unreasonable...

Arrgh...  My apologies - it had sat applied since 25th, but hadn't been
pushed and pull request hadn't been sent.  Linus, could you pull
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Stephen Warren (1):
      namei.h: include errno.h

Diffstat:
 include/linux/namei.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
