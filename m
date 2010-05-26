Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0EZN4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:56:24 -0400
Received: from www.tglx.de ([62.245.132.106]:43070 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab0EZN4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:56:22 -0400
Date: Wed, 26 May 2010 15:56:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Egger <siccegge@cs.fau.de>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jon Hunter <jon-hunter@ti.com>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] transitional config CONFIG_GENERIC_CLOCKEVENTS
In-Reply-To: <20100526134415.GD7508@faui49.informatik.uni-erlangen.de>
Message-ID: <alpine.LFD.2.00.1005261554280.2995@localhost.localdomain>
References: <20100526134415.GD7508@faui49.informatik.uni-erlangen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Christoph Egger wrote:

> Hi all!
> 
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we are looking at multiple integrity errors in linux'
> configuration system.
> 
> 	This was an aid for a transition finished 2007 so not
> necessary for some time now, ready for removal.
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.

It's still necessary/helpful for any arch which is not yet
converted. And there are a few unfortunately.
 
Thanks,

	tglx
