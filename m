Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab2JCXZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:25:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59526 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932350Ab2JCXZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:25:11 -0400
X-Sasl-enc: fg7TKhL6hc1xWPpOasAVBaoJ+odP343UVEYhUn20kflo 1349306711
Date: Wed, 3 Oct 2012 16:25:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [GIT PULL] user namespace compile fix for 3.7
Message-ID: <20121003232510.GC14392@kroah.com>
References: <87626r17l1.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87626r17l1.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:03:54PM -0700, Eric W. Biederman wrote:
> 
> Linus,
> 
> Please pull the for-linus git tree from:
> 
>    git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus
> 
>    HEAD: 702e490211b2b7e448ebe1b3a07d97ad2fc07e03 userns: Fix build of drivers/staging/dgrp
> 
> This tree contains a trivial build fix for one of the staging drivers
> when user namespace support is enabled.

Is this something new?  Why didn't it show up in the linux-next builds?

I'll be glad to take this single patch myself and queue it up with other
staging tree fixes before 3.7-final is out, what is the big rush?

thanks,

greg k-h
