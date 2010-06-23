Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0FWWi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:38:26 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:50571 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab0FWWiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:38:25 -0400
Message-Id: <201006232235.AA00445@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Thu, 24 Jun 2010 07:35:34 +0900
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dmitry Torokhov <dtor@mail.ru>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100622131654.05032c22.akpm@linux-foundation.org>
References: <20100622131654.05032c22.akpm@linux-foundation.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 22 Jun 2010 13:16:54 -0700 Andrew Morton wrote:

> > To keep panic_timeout accuracy when running under a hypervisor, the
> > current implementation only spins on long time (1 second) calls to
> > mdelay.  That brings a good effect, but the problem is the keyboard
> > LEDs don't blink at all on that situation.
> > 
> > This patch changes to call to panic_blink_enter() between every mdelay
> > and keeps blinking in spite of long spin timer mode.
> > 
> > The time to call to mdelay is now 100ms.  Even this change will keep
> > panic_timeout accuracy enough when running under a hypervisor.
> 
> Thaks for sticking with it - I think the code's a lot better now.  Are
> you happy with it?

Oh, yes.  That's very thoughtful of you.

Regards,
TAMUKI Shoichi
