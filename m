Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1LTEIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 23:08:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38006 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1LTEId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 23:08:33 -0500
Date: Tue, 20 Dec 2011 05:08:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, trenn@suse.de, kay.sievers@vrf.org,
        Andi Kleen <ak@linux.intel.com>, kay.sievers@vrfy.org, axboe@kernel.dk,
        herbert@gondor.hengli.com.au, ying.huang@intel.com
Subject: Re: [PATCH 03/10] crypto: Add support for x86 cpuid auto loading for x86 crypto drivers
Message-ID: <20111220040829.GD5637@one.firstfloor.org>
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org> <1324334865-30459-4-git-send-email-andi@firstfloor.org> <20111219232246.GB570@redhat.com> <4EEFC7D2.70803@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEFC7D2.70803@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The first printk is insanely annoying, because the end result is that we
> get a printk of all the crypto engines that are *not* enabled...
> arguably it would be somewhat nice to get a printk when a crypto engine
> *is* enabled.

Yes that was my rationale. I have some Intel system complaining that
some VIA crypto is not available. That's very annoying and just has
to go.

-Andi
