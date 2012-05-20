Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2ETQUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:20:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:61195 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2ETQUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:20:10 -0400
Date: Sun, 20 May 2012 12:20:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Chris Metcalf <cmetcalf@tilera.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: set KBUILD_DEFCONFIG to point at a real config file
Message-ID: <20120520162005.GB21177@windriver.com>
References: <1337381165-7376-1-git-send-email-paul.gortmaker@windriver.com>
 <4FB6F28F.3090404@tilera.com>
 <20120519031806.GA24697@windriver.com>
 <4FB7A856.4090803@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FB7A856.4090803@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] tile: set KBUILD_DEFCONFIG to point at a real config file] On 19/05/2012 (Sat 10:04) Chris Metcalf wrote:

> On 5/18/2012 11:18 PM, Paul Gortmaker wrote:

[...]

> >
> > So maybe some validation on the ARCH value is in order if you really
> > don't want people doing this?
> 
> Yes.  I think what I will do is "promote" ARCH=tile to ARCH=tilegx in
> arch/tile/Makefile as the "default" Tilera architecture.  Thanks for the
> suggestion - I've been too close to this issue to actually notice it :-)

No problem, I figured that was the case -- that setting ARCH=tile never
crossed your mind since you already knew what was expected by your own
Makefile.  :)

Paul.

> 
> -- 
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
> 
