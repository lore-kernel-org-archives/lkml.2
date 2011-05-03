Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1ECW01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:26:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36701 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752902Ab1ECW00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:26:26 -0400
Date: Tue, 3 May 2011 23:26:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110503222635.GA8035@opensource.wolfsonmicro.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
 <20110503163128.24853.15446.stgit@bob.linux.org.uk>
 <20110503174254.GA6545@kroah.com>
 <20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
 <20110503213925.GA7453@opensource.wolfsonmicro.com>
 <20110503225316.5371c96b@lxorguk.ukuu.org.uk>
 <20110503220233.GB14080@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503220233.GB14080@kroah.com>
X-Cookie: Stay away from hurricanes for a while.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 03:02:33PM -0700, Greg KH wrote:

> Mark, can you try to let me know if you are patching staging code?  If
> you want to "own" a driver in the staging tree, that's fine, just let me
> konw and I'll funnel patches to you for it (we do that for other staging
> drivers).

I CCed you in on the thread where the patch was applied.  Probably you
forgot about it as it was described as a build fix for my tree.

I'm not really that interested in the Intel patches in staging, the bulk
of them require a from scratch rewrite to go upstream as they're so far
from following the Linux driver model for these things.
