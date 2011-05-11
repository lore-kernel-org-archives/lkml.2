Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab1EKQLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:11:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57839 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756354Ab1EKQL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:11:29 -0400
Date: Wed, 11 May 2011 18:11:31 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@suse.de>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ASoC: Update cx20442 for TTY API change
Message-ID: <20110511161131.GB31593@opensource.wolfsonmicro.com>
References: <1305122744-30197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110511155535.GB20920@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511155535.GB20920@suse.de>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 08:55:35AM -0700, Greg KH wrote:

> Do you want me to take this through the tty tree, or do you want to take
> it through the SOC sound tree?  If you want to do it, that's fine with
> me, whatever is easier for you.

Please apply it to your tree - the problem that this fixes was
introduced by a patch in your tree in -next so it'd introduce breakage
in my tree if I'd applied it anyway.
