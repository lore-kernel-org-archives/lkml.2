Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2KSAPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:15:17 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36420 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2KSAPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:15:15 -0500
Date: Sun, 18 Nov 2012 16:12:05 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivres/power/jz4740-battery.c: Use
 devm_request_and_ioremap
Message-ID: <20121119001205.GF29066@lizard.sbx05977.paloaca.wayport.net>
References: <1352243472-14951-1-git-send-email-marcos.souza.org@gmail.com>
 <1352243472-14951-3-git-send-email-marcos.souza.org@gmail.com>
 <509CCFF3.60706@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <509CCFF3.60706@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 10:42:11AM +0100, Lars-Peter Clausen wrote:
> On 11/07/2012 12:11 AM, Marcos Paulo de Souza wrote:
> > No functional changes. Just a cleanup.
> > 
> > Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> 
> Looks good to me:
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks for the patches and for the reviews!

> One minor comment though:
[...]
> devm_request_and_ioremap will print its own error messages if it fails, so
> strictly speaking this is not necessary, but I don't think it is worth doing
> resend just for this.

> Anton, maybe you can just remove the line when applying the patch.

Sure, I fixed it up and applied.

Anton.
