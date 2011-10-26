Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab1JZNra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:47:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932755Ab1JZNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:47:28 -0400
Date: Wed, 26 Oct 2011 14:47:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wm8400-core: select REGMAP_I2C in kconfig
Message-ID: <20111026134726.GA3813@opensource.wolfsonmicro.com>
References: <20111025185359.GA21019@redhat.com> <20111026071256.GA2915@opensource.wolfsonmicro.com> <20111026134358.GA2048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026134358.GA2048@redhat.com>
X-Cookie: You are number 6!  Who is number one?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 09:43:58AM -0400, Dave Jones wrote:

> That was yesterdays git (don't have the hash handy).  Today, as of
> efb8d21b2c6db3497655cc6a033ae8a9883e4063 I can't reproduce it, though
> I don't know why, as that file is definitly still using regmap, and there's
> no select, and it's not in my .config.

I guess it's not terribly important so long as the patch I mentioned
that's in Samuel's tree makes it in during the merge window.
