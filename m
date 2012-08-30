Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2H3MRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 08:17:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47416 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2H3MRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:17:47 -0400
Date: Thu, 30 Aug 2012 05:15:21 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/8] lp8727_charger: cleanup code
Message-ID: <20120830121521.GC11289@lizard>
References: <A874F61F95741C4A9BA573A70FE3998F41EF1C6B@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF1C6B@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:37:16AM +0000, Kim, Milo wrote:
> LP8727 driver should be patched for several reasons.
> 
> (a) Need to clean up _probe()/_remove()
> (b) Not secure code when the platform data is NULL
> (c) Interrupt handling
>     Two threads are running for handling one IRQ.
>     One is for the IRQ pin, the other is used for delayed processing.
>     This is unusual and can be enhanced.
> (d) Misuse of mutex code
> (e) Lots of definitions should be fixed
> (f) Others..

Thanks a lot for the cleanups, this is much appreciated! The cleanups
themselves look great, but I'd really like to see them more separated.

Thanks,
Anton.
