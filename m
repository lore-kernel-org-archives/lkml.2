Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0F1Ues (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:34:48 -0400
Received: from legolas.restena.lu ([158.64.1.34]:57361 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0F1Uen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:34:43 -0400
Date: Mon, 28 Jun 2010 22:26:41 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [Patch 0/4] HID: Fix PicoLCD to allow it to run fbcon and handle
 unplug while FB in use
Message-ID: <20100628222641.489c955a@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1006241053360.13809@pobox.suse.cz>
References: <20100509184911.3f136b77@neptune.home>
	<AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
	<20100510080047.5adade6f@pluto.restena.lu>
	<20100526215829.28a4aa47@neptune.home>
	<20100530130945.5c03797f@neptune.home>
	<20100623123225.4c16e653@neptune.home>
	<alpine.LNX.2.00.1006241053360.13809@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 24 June 2010 Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 23 Jun 2010, Bruno Prémont wrote:
> > Do you think This patch can be applied as-is or should I break it up
> > into 2 or 3 patches (one for the 8bpp NULL-pointer dereference,
> > one for switch between 1bpp and 8bpp and one for the refcounting of
> > framebuffer to get things polite on unplug while framebuffer is still
> > in use?
> 
> Hi Bruno,
> 
> splitting would definitely improve readability and reviewability (even 
> more so for someone like me, who is not really familiar with the 
> framebuffer stuff).
> 
> Still it'd be nice if you could collect Ack from someone more familiar 
> with the framebuffer code.

Here it comes, split into 4 patches.

Thanks,
Bruno
