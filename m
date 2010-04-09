Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0DIULb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:11:31 -0400
Received: from tex.lwn.net ([70.33.254.29]:54064 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab0DIULa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:11:30 -0400
Date: Fri, 9 Apr 2010 14:11:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/16] viafb: Determine type of 2D engine and store it
 in chip_info
Message-ID: <20100409141127.42e4e1fa@bike.lwn.net>
In-Reply-To: <4BBE9CFC.2020804@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-6-git-send-email-corbet@lwn.net>
	<4BBE9CFC.2020804@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 05:20:28 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> Just a minor nit:
> Could we change the default so that if someone adds support for a new 
> IGP (and misses this function) we default to either the newest or 
> preferably to none? I've just seen too much poorly maintained code in 
> this driver and defaulting to the oldest is hence a bad idea.
> Otherwise it's fine.

That would require making an exhaustive list of older chipset types.
It could probably be inferred through inspection of the code, but I
worry about making assumptions in this area...

Thanks,

jon
