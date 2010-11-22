Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0KVTjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:39:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38370
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757186Ab0KVTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:39:21 -0500
Date: Mon, 22 Nov 2010 11:39:47 -0800 (PST)
Message-Id: <20101122.113947.48491153.davem@davemloft.net>
To: jslaby@suse.cz
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org, hch@lst.de,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] IDE: ide-floppy, remove unnecessary NULL check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289034412-24278-3-git-send-email-jslaby@suse.cz>
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
	<1289034412-24278-3-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Sat,  6 Nov 2010 10:06:51 +0100

> Stanse founf that rq in ide_floppy_callback cannot be NULL, because it
> is dereferenced all around. So remove the superfluous check.
> 
> This appeared after blk_* macors removal.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Applied with commit message typos fixed.

Thanks.
