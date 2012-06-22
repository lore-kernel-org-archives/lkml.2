Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab2FVVN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:13:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34305 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab2FVVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:13:24 -0400
Date: Sat, 23 Jun 2012 01:13:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Per Forlin <per.forlin@stericsson.com>,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Per Forlin <per.lkml@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] reboot: disable nonboot CPUs
Message-ID: <20120622211319.GI2907@moon>
References: <1339709115-531-1-git-send-email-per.forlin@stericsson.com>
 <CAGXu5jKqaddf3T+LMS-6VMgH98JbMG-NsjB8uajNw19R7OAfig@mail.gmail.com>
 <20120614214834.GB14301@moon>
 <20120622135704.658eb79c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622135704.658eb79c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 01:57:04PM -0700, Andrew Morton wrote:
> > since syscore_shutdown seems to call for generic irqs to shutdown
> > when cpu get turned off already, not sure if this have any side
> > effect and/or I've missed something (Thomas CC'ed).
> 
> Let's use the scientific method: stick it in the tree and see what
> happens. If it breaks, we fix or revert it.

yeah, i'll try to find some time on weekend for deeper review.

	Cyrill
