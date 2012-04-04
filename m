Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2DDTWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:22:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34149 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645Ab2DDTWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:22:40 -0400
Date: Wed, 4 Apr 2012 12:22:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tom Goff <thomas.goff@boeing.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] sysfs: Update the name hash for an entry after changing
 the namespace
Message-ID: <20120404192236.GA30172@kroah.com>
References: <20120404190620.GA8776@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404190620.GA8776@boeing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 12:06:20PM -0700, Tom Goff wrote:
> This is needed to allow renaming network devices that have been moved
> to another network namespace.
> 
> Signed-off-by: Tom Goff <thomas.goff@boeing.com>
> ---
>  fs/sysfs/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Is this a bug in 3.4-rc1 and older kernels?  If so, how old?

thanks,

greg k-h
