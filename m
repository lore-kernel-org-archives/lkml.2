Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0EDCha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 22:37:30 -0400
Received: from tex.lwn.net ([70.33.254.29]:53214 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab0EDCh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 22:37:29 -0400
Date: Mon, 3 May 2010 20:37:26 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 02/30] viafb: use proper pci config API
Message-ID: <20100503203726.5fcdc31c@bike.lwn.net>
In-Reply-To: <4BDC343A.5040901@gmx.de>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<1272493051-25380-3-git-send-email-corbet@lwn.net>
	<4BDC343A.5040901@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[One I never answered]

On Sat, 01 May 2010 16:01:30 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> I fear this check is wrong as
> 
> struct viafb_par {
> 	...
> 	unsigned int memsize;
> 	...
> }
> 
> so this check would as far as I see never return true *wonders why gcc 
> doesn't complain about it*

That is wrong, yes.  As it happens, this gets fixed later in the series
when things move into via-core.c.  I'd like to say that it's because I
noticed the problem and dealt with it, but you're smarter than that,
alas...

Thanks,

jon
