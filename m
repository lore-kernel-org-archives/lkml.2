Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab2AIUPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:15:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375Ab2AIUPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:15:11 -0500
Date: Mon, 9 Jan 2012 12:07:51 -0800
From: Greg KH <gregkh@suse.de>
To: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: Re: [PATCH] Updated TTY MAINTAINERS info
Message-ID: <20120109200751.GA8337@suse.de>
References: <1326137964-10671-1-git-send-email-lucaskt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326137964-10671-1-git-send-email-lucaskt@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 05:39:24PM -0200, Lucas Kannebley Tavares wrote:
> Greg Kroah-Hartman is the current TTY maintainer, however he wouldn't appear
> listed as such upon running get_maintainers.pl for drivers under
> drivers/tty/serial.
> 
> Signed-off-by: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc6a466..6a856df 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6641,7 +6641,7 @@ TTY LAYER
>  M:	Greg Kroah-Hartman <gregkh@suse.de>
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
> -F:	drivers/tty/*
> +F:	drivers/tty/

Isn't this just a bug in the get_maintainers.pl script?  Why does this
patch fix the problem?

greg k-h
