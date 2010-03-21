Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0CUXgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 19:36:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab0CUXgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 19:36:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [Bug #15494] BUG: key ffff88013d4f4c70 not in .data! when loading microcode.ko
Date: Mon, 22 Mar 2010 00:39:24 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.kfD.NOopLB@chimera> <20100321231749.GA8441@pengutronix.de>
In-Reply-To: <20100321231749.GA8441@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003220039.24151.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010, Wolfram Sang wrote:
> On Sun, Mar 21, 2010 at 09:30:51PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.32 and 2.6.33.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> 
> This is actually a regression from 2.6.33.

Thanks, corrected.

> It should haven been fixed in rc2 with
> e1955ca0ee55286cbc65a8ed7471d540ae83dac8.

And closed.

Rafael
