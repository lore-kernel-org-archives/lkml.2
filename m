Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1GHWaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 18:30:18 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55872 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064Ab1GHWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 18:30:16 -0400
X-Sasl-enc: QSTvgBu9b7ml3ZimEQLYs+rcKRWjAlWJFNwAfW+c87g7 1310164215
Date: Fri, 8 Jul 2011 15:29:51 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: kumar.gala@freescale.com, benh@kernel.crashing.org, akpm@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de
Subject: Re: tty/powerpc: introduce the ePAPR embedded hypervisor byte
 channel driver
Message-ID: <20110708222951.GA27363@kroah.com>
References: <1305830092-20104-1-git-send-email-timur@freescale.com>
 <20110708220654.GA19146@kroah.com>
 <4E178193.2090905@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E178193.2090905@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 05:15:47PM -0500, Timur Tabi wrote:
> Greg KH wrote:
> > Doesn't apply at all to the tty-next tree, so I can't apply it here :(
> 
> Um, where exactly is the tty-next tree?  The only thing I see that looks like it
> is this:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
> 
> But the description of this tree says, "junk tree, please ignore".

Don't ignore it, that's the one :)
