Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2FYRrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:47:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37662 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2FYRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:47:14 -0400
Date: Mon, 25 Jun 2012 10:47:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        trivial@kernel.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: int.c: A few trivial style cleanups
Message-ID: <20120625174709.GA3789@kroah.com>
References: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 10:12:12PM +0200, Jesper Juhl wrote:
> Removed a pointless cast + some whitespace cleanups.

Please break this up into different patches as you are doing multiple
things.

thanks,

greg k-h
