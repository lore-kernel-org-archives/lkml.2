Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2LJUcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:32:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64258 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2LJUcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:32:50 -0500
Date: Mon, 10 Dec 2012 12:32:46 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans.rullgard@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 266/270] ARM: 7566/1: vfp: fix save and restore when
 running on pre-VFPv3 and CONFIG_VFPv3 set
Message-ID: <20121210203246.GA21258@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-267-git-send-email-herton.krzesinski@canonical.com>
 <1355099334.20838.97.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355099334.20838.97.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 12:28:54AM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:59 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Paul Walmsley <paul@pwsan.com>
> > 
> > commit 39141ddfb63a664f26d3f42f64ee386e879b492c upstream.
> > 
> > After commit 846a136881b8f73c1f74250bf6acfaa309cab1f2 ("ARM: vfp: fix
> > saving d16-d31 vfp registers on v6+ kernels"), the OMAP 2430SDP board
> > started crashing during boot with omap2plus_defconfig:
> [...]
> > [ herton: no uapi directory on 3.5 ]
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> [...]
> 
> I've also queued this up for 3.2.  Greg, you'll want to add this to the
> other 3.x series since you applied commit 846a136881b8.

Thanks for letting me know, I've now queued it up after having to fix it
up a bit by hand for the 3.0-stable tree.

greg k-h
