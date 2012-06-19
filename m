Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2FSQoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:44:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36220 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2FSQoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:44:04 -0400
Date: Tue, 19 Jun 2012 09:43:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Lockwood <lockwood@android.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Subject: Re: [PATCH 1/2] extcon: Set platform drvdata in gpio_extcon_probe()
 and fix irq leak
Message-ID: <20120619164359.GA4571@kroah.com>
References: <22448380.601061340101146820.JavaMail.weblogic@epml24>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22448380.601061340101146820.JavaMail.weblogic@epml24>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 10:19:07AM +0000, 함명주 wrote:
> > Add missing platform_set_drvdata() in gpio_extcon_probe(), otherwise calling
> > platform_get_drvdata in gpio_extcon_remove() returns NULL.
> > 
> > Also add missing free_irq call in gpio_extcon_remove().
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Thanks!
> 
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> I'll apply this patch to the extcon-for-next.
> I would appear in http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next soon after syncing servers.

Does this mean you are going to have a separate extcon git tree
somewhere, feeding into linux-next, and sending stuff directly to Linus?

I don't see an entry in the MAINTAINERS file saying this, which is why I
was picking up extcon patches, should I not be doing this?

confused,

greg k-h
