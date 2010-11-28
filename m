Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0K1Tn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:43:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56787
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab0K1Tn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:43:56 -0500
Date: Sun, 28 Nov 2010 11:44:22 -0800 (PST)
Message-Id: <20101128.114422.233714708.davem@davemloft.net>
To: jslaby@suse.cz
Cc: netdev@vger.kernel.org, slapin@ossfans.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, andrew.hendry@gmail.com
Subject: Re: [PATCH 1/1] NET: wan/x25_asy, move lapb_unregister to
 x25_asy_close_tty
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290642894-4577-1-git-send-email-jslaby@suse.cz>
References: <1290642894-4577-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Thu, 25 Nov 2010 00:54:54 +0100

> We register lapb when tty is created, but unregister it only when the
> device is UP. So move the lapb_unregister to x25_asy_close_tty after
> the device is down.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: Sergey Lapin <slapin@ossfans.org>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>

Applied with commit message addition you mentioned Jiri.

Thanks.
