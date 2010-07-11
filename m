Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0GKU6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 16:58:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:60787 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab0GKU6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 16:58:41 -0400
Date: Sun, 11 Jul 2010 22:58:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 - adjusted changelog] HID: picolcd: fix deferred_io
 init/cleanup to  (un)register_framebuffer ordering
In-Reply-To: <20100630223631.49ab1c85@neptune.home>
Message-ID: <alpine.LNX.2.00.1007112258270.4741@pobox.suse.cz>
References: <20100509184911.3f136b77@neptune.home> <AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com> <20100510080047.5adade6f@pluto.restena.lu> <20100526215829.28a4aa47@neptune.home> <20100530130945.5c03797f@neptune.home> <20100623123225.4c16e653@neptune.home>
 <alpine.LNX.2.00.1006241053360.13809@pobox.suse.cz> <20100628222641.489c955a@neptune.home> <20100628222920.1127f8eb@neptune.home> <AANLkTingjmM4OmkdXl9IOUe5zsj0QxTdix1h34pVHWGl@mail.gmail.com> <20100630075657.47a325a6@pluto.restena.lu>
 <20100630223631.49ab1c85@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Bruno Prémont wrote:

> Adjust ordering if framebuffer (un)registration and defio init/cleanup
> to match the correct order (init defio, register FB ... unregister FB,
> cleanup defio)
> 
> Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
> I consider Jaya's reply as an ack to the patch.

Applied, thanks Bruno.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
