Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0FXURZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 16:17:25 -0400
Received: from tex.lwn.net ([70.33.254.29]:33319 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab0FXURY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 16:17:24 -0400
Date: Thu, 24 Jun 2010 14:17:21 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: JosephChan@via.com.tw, ScottFang@viatech.com.cn, FlorianSchandinat@gmx.de,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: section cleanup in viafb driver
Message-ID: <20100624141721.7fb644d7@bike.lwn.net>
In-Reply-To: <1276768884-19958-1-git-send-email-henne@nachtwindheim.de>
References: <1276768884-19958-1-git-send-email-henne@nachtwindheim.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 12:01:24 +0200
Henrik Kretzschmar <henne@nachtwindheim.de> wrote:

> This patch moves two functions from .devexit to .text,
> which are called on the probe error path.
> Also a function which is called by probe is moved
> from .text to .devinit.

Sorry, it took me a while to take a look at this.  The changes make
sense, thanks.  I have a few viafb bits and pieces, will collect them
into my tree shortly.

Thanks,

jon
