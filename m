Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0FXIys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 04:54:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:56788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab0FXIyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:54:46 -0400
Date: Thu, 24 Jun 2010 10:54:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] HID: Fix PicoLCD to allow it to run fbcon and handle
 unplug while FB in use
In-Reply-To: <20100623123225.4c16e653@neptune.home>
Message-ID: <alpine.LNX.2.00.1006241053360.13809@pobox.suse.cz>
References: <20100509184911.3f136b77@neptune.home> <AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com> <20100510080047.5adade6f@pluto.restena.lu> <20100526215829.28a4aa47@neptune.home> <20100530130945.5c03797f@neptune.home>
 <20100623123225.4c16e653@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010, Bruno Prémont wrote:

> Do you think This patch can be applied as-is or should I break it up
> into 2 or 3 patches (one for the 8bpp NULL-pointer dereference,
> one for switch between 1bpp and 8bpp and one for the refcounting of
> framebuffer to get things polite on unplug while framebuffer is still
> in use?

Hi Bruno,

splitting would definitely improve readability and reviewability (even 
more so for someone like me, who is not really familiar with the 
framebuffer stuff).

Still it'd be nice if you could collect Ack from someone more familiar 
with the framebuffer code.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
