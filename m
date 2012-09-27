Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2I0RhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:37:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50396 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2I0RhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:37:18 -0400
Date: Thu, 27 Sep 2012 21:37:14 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        gregkh@linuxfoundation.org, xemul@parallels.com
Subject: Re: [patch 1/2] tty: pty - Move TIOCPKT handling into pty.c
Message-ID: <20120927173714.GQ6618@moon>
References: <20120927165958.287690622@openvz.org>
 <20120927170137.722717394@openvz.org>
 <50648DE7.2060904@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50648DE7.2060904@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 07:33:27PM +0200, Jiri Slaby wrote:
> 
> Hi!
> 
> This check is not needed as the ioctls are master-only.

Hi, thanks, Jiri, i'll update (was hurry to provide patches
so missed this ;)

	Cyrill
