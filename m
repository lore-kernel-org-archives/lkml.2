Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0IBULx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:11:53 -0400
Received: from kroah.org ([198.145.64.141]:57322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858Ab0IBULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:11:51 -0400
Date: Thu, 2 Sep 2010 13:09:50 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: getting rid of __GFP_NOFAIL in tty_add_file
Message-ID: <20100902200950.GE16897@kroah.com>
References: <1283444276-19355-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283444276-19355-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 06:17:56PM +0200, Jiri Olsa wrote:
> hi,
> 
> added error handling for struct tty_file_private allocation,
> Fixed error paths in tty_open and ptmx_open.

Heh, look at the linux-next tree, there's already a patch from Pekka in
there that does this, but in a little different way.  Let me know if
that version doesn't work for you.

thanks,

greg k-h
