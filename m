Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2JPIdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:33:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47411 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2JPIdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:33:41 -0400
Date: Tue, 16 Oct 2012 12:33:37 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, xemul@parallels.com,
        jslaby@suse.cz
Subject: Re: [patch 1/3] tty: pty - Move TIOCPKT handling into pty.c
Message-ID: <20121016083337.GA3512@moon>
References: <20120927211032.576475929@openvz.org>
 <20120927211121.651422569@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927211121.651422569@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 01:10:33AM +0400, Cyrill Gorcunov wrote:
> Since this ioctl is for pty devices only move it to pty.c.
> 
> v2:
>  - drop PTY_TYPE_MASTER test since it's master peer
>    ioctl anyway (by jslaby@)
> 
> Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Jiri Slaby <jslaby@suse.cz>

Greg, Alan, what about this series? Is there anything else I should do?
