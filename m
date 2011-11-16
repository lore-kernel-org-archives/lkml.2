Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab1KPNz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:55:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab1KPNz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:55:26 -0500
Date: Wed, 16 Nov 2011 14:55:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] usb: gadget: drop "select
 USB_GADGET_S3C_HSOTG_PIO"
In-Reply-To: <1321433227.20271.257.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1111161453470.15187@pobox.suse.cz>
References: <1321225272.20271.107.camel@x61.thuisdomein>  <alpine.LNX.2.00.1111141055450.15187@pobox.suse.cz>  <1321266882.20271.130.camel@x61.thuisdomein> <1321433227.20271.257.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, Paul Bolle wrote:

> 0) All is OK: I've sent you eleven patches in this series. Two were
> taken by maintainers (drm and unicore32). Nine are now in trivial
> for-next. Two needed approval (powerpc/4xx and unicore32). powerpc/4xx
> got acked, and that ack is in your commit and unicore32 got taken by a
> maintainer.

Thanks for cross-checking.

> 1) For future series of this kind (if any): does my approach work for
> you? See, I basically have a list of potential problems that I work on
> in batches, but one by one. So I'll work on a handful of items on that
> list, drop the false positives, send a few to maintainers and send the
> rest to you. After that I quickly go do something else, as this is not
> the kind of stuff I like to do for hours on end.
> 
> 2) This means in such a series you'll get batches, a few days apart, of
> patches each whatever-it-takes apart. Is that more work on your side?

I don't really care ... as you can imagine, trivial queue is quite low on 
my priority list, so I am processing it in batches as well on a rather 
random basis.

-- 
Jiri Kosina
SUSE Labs
