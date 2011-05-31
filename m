Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1EaLgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:36:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab1EaLgE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:36:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110530223847.GA29245@leaf>
References: <20110530223847.GA29245@leaf>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 31 May 2011 20:35:37 +0900
Message-ID: <BANLkTikgqkd0BckvTrFwAOmJQ0ObP4OOjg@mail.gmail.com>
Subject: Re: [PATCH] uts: Make default hostname configurable, rather than
 always using "(none)"
To: Josh Triplett <josh@joshtriplett.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kel Modderman <kel@otaku42.de>,
        pkg-sysvinit-devel@lists.alioth.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 7:38 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>
> The "hostname" tool falls back to setting the hostname to "localhost" if
> /etc/hostname does not exist.  Distribution init scripts have the same
> fallback.  However, if userspace never calls sethostname, such as when
> booting with init=/bin/sh, or otherwise booting a minimal system without
> the usual init scripts, the default hostname of "(none)" remains,
> unhelpfully appearing in various places such as prompts
> ("root@(none):~#") and logs.  Furthermore, "(none)" doesn't typically
> resolve to anything useful.

Ok, I'm fine with this. So Ack as far as I'm concerned.

Does this make most sense through the networking tree, or what?

              Linus
