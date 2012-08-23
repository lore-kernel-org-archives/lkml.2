Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2HWCoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:44:00 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53817 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2HWCn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:43:57 -0400
Date: Wed, 22 Aug 2012 19:41:10 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Il Han <corone.il.han@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        werner <w.landgraf@ru.ru>
Subject: Re: [PATCH] twl4030: It would be better not to use the 0b-prefix.
Message-ID: <20120823024110.GE24471@lizard>
References: <1345189783-19200-1-git-send-email-corone.il.han@gmail.com>
 <20120817193046.7eeb758a@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120817193046.7eeb758a@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 07:30:46PM +1000, NeilBrown wrote:
[...]
> > -#define TWL4030_BBISEL_1000uA	0b11
> > +#define TWL4030_BBSEL_MASK	0x0c
[...]
> Thanks.  I'd been meaning to send that patch, but life got in the way
> recently.
> 
> Acked-by: NeilBrown <neilb@suse.de>

Thanks! Applied.
