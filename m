Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab2IFAGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:06:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40846 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759881Ab2IFAGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:06:18 -0400
Date: Thu, 6 Sep 2012 08:06:13 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH -next] soc: fix wm0010.c printk format warning
Message-ID: <20120906000612.GO10580@opensource.wolfsonmicro.com>
References: <20120905161230.3bab1de6d4c8c8e466c3b0df@canb.auug.org.au>
 <5047DF49.6070502@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5047DF49.6070502@xenotime.net>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 04:24:57PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warning:

Somone already sent this.  As ever please try to use subject lines
appropriate for the subsystem.  Please also consider who you're CCing -
there's no need to copy -next on things like this which aren't
integration issues for example, if we start doing that then it'd get
drowned in noise from all the development.
