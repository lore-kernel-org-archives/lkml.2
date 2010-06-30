Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0F3J22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:28:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab0F3J20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:28:26 -0400
Date: Wed, 30 Jun 2010 11:28:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch 0/4] HID: Fix PicoLCD to allow it to run fbcon and handle
 unplug while FB in use
In-Reply-To: <20100628222641.489c955a@neptune.home>
Message-ID: <alpine.LNX.2.00.1006301127540.13809@pobox.suse.cz>
References: <20100509184911.3f136b77@neptune.home> <AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com> <20100510080047.5adade6f@pluto.restena.lu> <20100526215829.28a4aa47@neptune.home> <20100530130945.5c03797f@neptune.home> <20100623123225.4c16e653@neptune.home>
 <alpine.LNX.2.00.1006241053360.13809@pobox.suse.cz> <20100628222641.489c955a@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Bruno Prémont wrote:

> > splitting would definitely improve readability and reviewability (even 
> > more so for someone like me, who is not really familiar with the 
> > framebuffer stuff).
> > 
> > Still it'd be nice if you could collect Ack from someone more familiar 
> > with the framebuffer code.
> 
> Here it comes, split into 4 patches.

As the only objection from framebuffer people has been for changelog 
wording of 1/4, could you please fix that up, and I'll apply the series?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
