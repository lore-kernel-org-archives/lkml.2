Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2GGXGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:06:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55609 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2GGXF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:05:59 -0400
Date: Sat, 7 Jul 2012 16:05:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@android.com>
Cc: NeilBrown <neilb@suse.de>, Andrew Boie <andrew.p.boie@intel.com>,
        arve@android.com, rebecca@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcb: Android bootloader control block driver
Message-ID: <20120707230555.GA29514@kroah.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
 <20120630032333.GB3972@kroah.com>
 <CAMbhsRSYL3oE_mbdjyNbV453DddPNUyJBU2eLJhUNaASF1+MtA@mail.gmail.com>
 <20120630041928.GA1816@kroah.com>
 <CAMbhsRRUs1tHQ+DfWzhKE6M47+Rqu0uB4hQgX7d7ZGzaZi9uyw@mail.gmail.com>
 <20120702101057.2a8dd6a6@notabene.brown>
 <CAMbhsRSQhBTxA9g1b4Pc6px4gYcOzn4miOrS6ecdJmOQ+RNSGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRSQhBTxA9g1b4Pc6px4gYcOzn4miOrS6ecdJmOQ+RNSGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 03:39:09PM -0700, Colin Cross wrote:
> On many (most?) ARM SoCs, the reboot flag is not stored on disk, or
> anywhere else userspace can access.  It is stored in a power
> management controller scratch register that survives resets, or a
> register in an external I2C PMIC, or in internal SoC RAM (I've seen
> all of these).  For your proposal, every SoC would need a custom API
> to save the reboot flag somewhere.  For these devices, it clearly
> makes more sense to use something like the REBOOT2 API, and if we have
> to use it on some devices, it makes no sense to me to not use it on
> other devices just because userspace could theoretically handle it.

That's fine, but that is not what this patch did at all.

Propose a patch that handles writing to those types of registers and we
will be glad to review it.

thanks,

greg k-h
