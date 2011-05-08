Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1EHOA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:00:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54839 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751368Ab1EHOAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:00:55 -0400
Date: Sun, 8 May 2011 15:01:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] soc: fix wm8958-dsp2 printk format warnings
Message-ID: <20110508140101.GB15968@opensource.wolfsonmicro.com>
References: <20110505134959.b3761297.sfr@canb.auug.org.au>
 <20110506161310.54b22b9f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506161310.54b22b9f.randy.dunlap@oracle.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 04:13:10PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings in wm8958-dsp2.c:

Please do try to follow the standard patch submission process:

- Send patches to maintainers.
- Send patches to the relevant mailing lists.
- Use the relevant subsystem prefix in your commit message.
