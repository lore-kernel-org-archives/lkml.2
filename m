Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1BIUyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:54:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825Ab1BIUyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:54:32 -0500
MIME-Version: 1.0
In-Reply-To: <4D525EF00200007800030F0F@vpn.id2.novell.com>
References: <4D525EF00200007800030F0F@vpn.id2.novell.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Feb 2011 12:54:10 -0800
Message-ID: <AANLkTinu3q==3kAaXkUBorOX7NG49w+X77ZZQifhhJ+Z@mail.gmail.com>
Subject: Re: [PATCH] fix jiffy calculations in calibrate_delay_direct to
 handle overflow
To: Jan Beulich <JBeulich@novell.com>
Cc: akpm@linux-foundation.org, Tim Deegan <Tim.Deegan@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 12:31 AM, Jan Beulich <JBeulich@novell.com> wrote:
> Fixes a hang when booting as dom0 under Xen, when jiffies can be
> quite large by the time the kernel init gets this far.
>
> Signed-off-by: Tim Deegan <Tim.Deegan@citrix.com>
>
> !time_after() -> time_before_eq() as per suggestion from Jiri Slaby.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>

So I have nothing against the patch, but the changelog is broken.

Is Tim the original author? If so, why wasn't that noted? I'm just
guessing from that random signed-off line in the middle of the thing.

Please guys, don't drop authorship attributions, or alternatively
don't confuse me with odd random sign-off lines in the middle of the
message.

                              Linus
