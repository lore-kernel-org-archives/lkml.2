Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0GLGRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:17:08 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:42279 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0GLGRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:17:06 -0400
Date: Mon, 12 Jul 2010 08:17:11 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 - adjusted changelog] HID: picolcd: fix deferred_io
 init/cleanup to  (un)register_framebuffer ordering
Message-ID: <20100712081711.25793f9d@pluto.restena.lu>
In-Reply-To: <alpine.LNX.2.00.1007112258270.4741@pobox.suse.cz>
References: <20100509184911.3f136b77@neptune.home>
	<AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
	<20100510080047.5adade6f@pluto.restena.lu>
	<20100526215829.28a4aa47@neptune.home>
	<20100530130945.5c03797f@neptune.home>
	<20100623123225.4c16e653@neptune.home>
	<alpine.LNX.2.00.1006241053360.13809@pobox.suse.cz>
	<20100628222641.489c955a@neptune.home>
	<20100628222920.1127f8eb@neptune.home>
	<AANLkTingjmM4OmkdXl9IOUe5zsj0QxTdix1h34pVHWGl@mail.gmail.com>
	<20100630075657.47a325a6@pluto.restena.lu>
	<20100630223631.49ab1c85@neptune.home>
	<alpine.LNX.2.00.1007112258270.4741@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010 22:58:37 Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 30 Jun 2010, Bruno Prémont wrote:
> 
> > Adjust ordering if framebuffer (un)registration and defio
> > init/cleanup to match the correct order (init defio, register
> > FB ... unregister FB, cleanup defio)
> > 
> > Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
> > Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> > ---
> > I consider Jaya's reply as an ack to the patch.
> 
> Applied, thanks Bruno.

Thanks for applying, what about the 3 other patches of the series?

For the last one, I will have a look at putting ref-counting support
info FB so this can be shared, e.g. with Bernie's udlfb (unless he
is quicker than me). Until that is written and merged it's certainly
wise to have the refcounting locally.

Thanks,
Bruno
