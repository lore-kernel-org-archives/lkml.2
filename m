Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1IVXBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:01:14 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33324 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777Ab1IVXBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:01 -0400
X-Sasl-enc: cM7EYEwyyy9pciZxgGMOXp+MGhPKm2UeDLb8hYmGUUaa 1316732460
Date: Thu, 22 Sep 2011 15:46:53 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
Message-ID: <20110922224653.GB21296@kroah.com>
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 09:24:56PM +0200, Jiri Slaby wrote:
> Commit "TTY: serial, move locking in uart_close" moved the lock, but
> omitted to update branches which unlock the lock. Now they try to
> unlock the lock without holding it.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
> If possible, please, merge this into the patch mentioned above (it's
> not upstream yet).

I can't do that, and Nobuhiro Iwamatsu sent this to me before you, so
I'll take his version instead, if you don't mind.

thanks,

greg k-h
