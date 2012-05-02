Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2EBPbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:31:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47466 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2EBPbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:31:05 -0400
Date: Wed, 2 May 2012 08:31:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: New debugfs interface for creation of files,
 directory and symlinks
Message-ID: <20120502153100.GA2777@kroah.com>
References: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 06:20:54PM +0530, Sasikantha babu wrote:
> As we know the current debugfs file or directory or symlink creation
> doesn't return proper error codes to the caller on failure. Because 
> of this caller and user could not able to find the exact reason of
> the failure.

And what is the problem with this?  Either the file is created or not,
you really shouldn't care anymore than that.  It's not like you are
going to retry the creation, or are you?

Who really cares if the file is failed to be created?

> As Andrew Morton suggested (http://www.spinics.net/lists/linux-mm/msg33617.html)
> introduced new debugfs interface to create debugfs entries. Newer APIs 
> returns proper error codes(ERR_PTR) on failure.

Again, why?  What root problem are you trying to solve here?

thanks,

greg k-h
