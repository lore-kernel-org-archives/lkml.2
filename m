Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3AFPvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 10:51:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37567 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3AFPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 10:51:49 -0500
Date: Sun, 6 Jan 2013 15:51:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] namei.h: Include errno.h
Message-ID: <20130106155146.GG4939@ZenIV.linux.org.uk>
References: <1357487329-32034-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357487329-32034-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 07:48:49AM -0800, Guenter Roeck wrote:
> Commit b9d6ba94 (vfs: add a retry_estale helper function to handle retries
> on ESTALE) intruduced the use of ESTALE in namei.h. Since namei.h does not
> include errno.h, this results in the following build error for callers/users
> which do not include errno.h directly.
> 
> include/linux/namei.h:114:19: error: 'ESTALE' undeclared (first use in this
> function)
> 
> Add the missing include.

That's the third patch doing the same thing; see vfs.git#for-linus for the
earliest one.  Still not pulled...
