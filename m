Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab1EKQ3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:29:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34480 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755303Ab1EKQQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:16:41 -0400
Date: Wed, 11 May 2011 18:16:43 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ASoC: fix wm8958-dsp2 printk format warnings
Message-ID: <20110511161642.GA31677@opensource.wolfsonmicro.com>
References: <20110505134959.b3761297.sfr@canb.auug.org.au>
 <20110506161310.54b22b9f.randy.dunlap@oracle.com>
 <20110508140101.GB15968@opensource.wolfsonmicro.com>
 <4DC6B8F7.4000302@oracle.com>
 <20110508160604.GB32214@opensource.wolfsonmicro.com>
 <20110508094824.b6952ae6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508094824.b6952ae6.randy.dunlap@oracle.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 09:48:24AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings in wm8958-dsp2.c:

Applied, thanks.  With warnings like this it's useful to note which
platform you see things on - this doesn't occur on ARM for example.  I
suspect it's a 64 bit or compiler version issue but ICBW.
