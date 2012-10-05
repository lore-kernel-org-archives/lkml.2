Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab2JEQZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:25:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50995 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab2JEQZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:25:45 -0400
Date: Fri, 5 Oct 2012 09:25:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: samuel@sortiz.org, davem@davemloft.net, jslaby@suse.cz,
        alan@linux.intel.com, levinsasha928@gmail.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net, TTY: initialize tty->driver_data before usage
Message-ID: <20121005162531.GA15434@kroah.com>
References: <1349395281-12495-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349395281-12495-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 08:01:21PM -0400, Sasha Levin wrote:
> Commit 9c650ffc ("TTY: ircomm_tty, add tty install") split _open() to
> _install() and _open(). It also moved the initialization of driver_data
> out of open(), but never added it to install() - causing a NULL ptr
> deref whenever the driver was used.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> Acked-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  net/irda/ircomm/ircomm_tty.c | 2 ++
>  1 file changed, 2 insertions(+)

Nice catch, now applied.

greg k-h
