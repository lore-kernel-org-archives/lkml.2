Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab0I0BcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 21:32:13 -0400
Received: from kroah.org ([198.145.64.141]:33575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757665Ab0I0BcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 21:32:12 -0400
Date: Sun, 26 Sep 2010 18:22:55 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: make new character devices nonseekable
Message-ID: <20100927012255.GA16490@kroah.com>
References: <201009261731.53062.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009261731.53062.arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 05:31:52PM +0200, Arnd Bergmann wrote:
> As a preparation for changing the default behaviour of llseek to no_llseek,
> every file_operations structure should have a .llseek operation.
> 
> There are three new instances in staging now, which can all be changed
> into no_llseek explicitly since the devices do not need to seek.
> 
> Add nonseekable_open where appropriate, to prevent pread/pwrite as well.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  bcm/Bcmchar.c                    |    3 +++
>  bcm/InterfaceInit.c              |    1 +
>  ft1000/ft1000-usb/ft1000_chdev.c |    2 ++
>  3 files changed, 6 insertions(+)

Odd, this patch breaks the build, what's up?

Hm, do I need to apply it to a recent Linus version?  My staging-next
tree is 2.6.36-rc2 based, do I need to update it?

thanks,

greg k-h
