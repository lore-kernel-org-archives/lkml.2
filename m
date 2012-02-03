Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab2BCCL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:11:26 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52763 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2BCCLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:11:25 -0500
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 18:11:17 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Woogyom Kim <milo.kim@ti.com>
Subject: Re: [PATCH] include/linux/lp8727.h: Remove executable bit
Message-ID: <20120203021117.GB13456@leaf>
References: <20120202232908.GA20195@leaf>
 <20120202235012.GA10004@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202235012.GA10004@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 03:50:12AM +0400, Anton Vorontsov wrote:
> On Thu, Feb 02, 2012 at 03:29:08PM -0800, Josh Triplett wrote:
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> > First time I've sent a patch with this diffstat, but I assume git can
> > properly apply it.
> 
> Woogyom Kim sent a similar fix some time ago.
> 
> http://lkml.org/lkml/2012/1/25/392

Ah, fair enough.  Glad to see it fixed in any case.

- Josh Triplett
