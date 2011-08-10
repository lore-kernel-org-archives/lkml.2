Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1HJJey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:34:54 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:47050 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1HJJex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:34:53 -0400
Date: Wed, 10 Aug 2011 03:34:52 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: Daniel Morsing <daniel.morsing@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: Build failure: bisected: v3.1-rc1 with config ARCH_OMAP &&
 !ARCH_OMAP4 fails with linker error
In-Reply-To: <20110810092139.GD1939@atomide.com>
Message-ID: <alpine.DEB.2.00.1108100333520.12674@utopia.booyaka.com>
References: <1312819724.14483.29.camel@morsingpad> <alpine.DEB.2.00.1108081435340.4764@utopia.booyaka.com> <20110809131453.GR1866@atomide.com> <alpine.DEB.2.00.1108092102580.12674@utopia.booyaka.com> <alpine.DEB.2.00.1108100045270.12674@utopia.booyaka.com>
 <20110810092139.GD1939@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011, Tony Lindgren wrote:

> Thanks yes that does the trick. I'd like to queue this immediately so we
> have more time to look at the other fixes if you don't mind.

That's fine, feel free to send this first.  Will try to have the rest of 
my 3.1-rc fixes ready to go in a few days.

> I noticed some checkpatch warnings, updated patch below. Does that look
> OK to you?

Fine by me.

- Paul
