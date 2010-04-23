Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0DWV5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:57:30 -0400
Received: from tex.lwn.net ([70.33.254.29]:59153 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425Ab0DWV52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:57:28 -0400
Date: Fri, 23 Apr 2010 15:57:25 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA
 framebuffer driver
Message-ID: <20100423155725.7d3b2d2d@bike.lwn.net>
In-Reply-To: <4BD20D56.7080402@gmx.de>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
	<1271614873-5952-11-git-send-email-corbet@lwn.net>
	<4BD20D56.7080402@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 23:12:54 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> 1. while the module loads the screen shows some strange colours. The 
> colours itself do not worry me but it probably at least means that the 
> module load time was increased significantly (2-3 seconds, I guess)
> 
> 2. most annoyingly after this patch I can no longer get a working VGA 
> console after unbinding the module. Normally I just do:

Hmm...compiling the driver as a module is not really something that
makes sense on the OLPC platform, so I've never done it.

#1 is weird, there should be nothing there that slows initialization
down.  Putting in some prints and looking at the timing would be most
helpful here.

As for #2, I can certainly say that I've never unloaded this code, so
that's an untested path.  I'll have a look and see if I can see
anything obvious.

jon
