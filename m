Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab0GBT7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 15:59:42 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48738 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759992Ab0GBT7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 15:59:30 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH] [resend] intel_agp: Don't oops with zero stolen memory
Date: Fri, 2 Jul 2010 21:59:20 +0200
User-Agent: KMail/1.9.10
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <201006161013.53612.linux@rainbow-software.org> <87aaqa2560.fsf@pollan.anholt.net>
In-Reply-To: <87aaqa2560.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007022159.21848.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010 00:44:39 Eric Anholt wrote:
> On Wed, 16 Jun 2010 10:13:52 +0200, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > When "onboard video memory" is set do "disabled" in BIOS on Asus
> > P4P800-VM board (i865G), kernel oopses with memory corruption:
> > https://bugs.freedesktop.org/show_bug.cgi?id=28430
> >
> > Fix that by cleanly aborting the initialization.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> I haven't seen a system with that option before. Is the integrated
> graphics still supposed to work at that point, or is it "graphics is
> disabled."?  What do other OSes do here?

Testing it right now with Windows XP. Integrated graphics works as secondary 
only when the "onboard video memory" is set to "disabled"! If anything other 
is set (e.g. 1MB or 32MB), the driver does not load (code 10).

-- 
Ondrej Zary
