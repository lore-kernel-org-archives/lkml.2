Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab1DEBKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 21:10:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab1DEBKq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 21:10:46 -0400
MIME-Version: 1.0
In-Reply-To: <yun4o6dik8g.fsf@aiko.keithp.com>
References: <alpine.DEB.2.00.1104050137040.8684@skynet.skynet.ie> <yun4o6dik8g.fsf@aiko.keithp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Apr 2011 18:09:55 -0700
Message-ID: <BANLkTimtAy7wTq8dbhy3LKVHAM=pS6A4-w@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 6:02 PM, Keith Packard <keithp@keithp.com> wrote:
> On Tue, 5 Apr 2011 01:38:31 +0100 (IST), Dave Airlie <airlied@linux.ie> wrote:
>
>>       drm/i915: Reset GMBUS controller after NAK
>
> We've got a report of a regression from this patch and have a fix in
> review right now. Please don't merge this to master until that fix has
> been verified and added to this sequence.

Gaah. Too late. I had already pulled and pushed out.

I'm not doing an -rc2 until tomorrow, though, so hopefully the issue
will be resolved and a fix pushed to me by then.

                        Linus
