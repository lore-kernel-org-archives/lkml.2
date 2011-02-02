Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1BBUkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:40:46 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47811 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1BBUkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:40:45 -0500
Date: Wed, 2 Feb 2011 12:40:31 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
Message-ID: <20110202204031.GB5503@outflux.net>
References: <4D41E86D.8060205@free.fr>
 <20110127230013.GO4981@outflux.net>
 <4D4228CE.5090601@zytor.com>
 <20110131213847.GF4557@outflux.net>
 <4D474194.2000709@free.fr>
 <20110131235231.GJ4557@outflux.net>
 <4D475D6B.4030508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D475D6B.4030508@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 05:10:03PM -0800, H. Peter Anvin wrote:
> On 01/31/2011 03:52 PM, Kees Cook wrote:
> >
> >This worked, thanks! If this tests cleanly for you in qemu, we should get
> >this committed.
> >
> 
> This is wrong for at least one reason; possibly two:
> 
> a) it ignores the control to not reload the segment registers (not
> sure if anything still uses them, but...)
> 
> b) I'm not sure that init_thread_union is safe for the non-BSP CPU here.

What's the best way to move forward? Or, how can we find answers to these
questions?

-Kees

-- 
Kees Cook
Ubuntu Security Team
