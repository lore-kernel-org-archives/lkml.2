Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1HSLxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:53:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65287 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1HSLxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yKHQGrY4kbwd+VPsg1ggj3wQqoN+uPLmh31RnhbroysQ@mail.gmail.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4yKHQGrY4kbwd+VPsg1ggj3wQqoN+uPLmh31RnhbroysQ@mail.gmail.com>
Date: Fri, 19 Aug 2011 13:53:12 +0200
Message-ID: <CACRpkdZB7XaB1SxWdqU1-176oab0zMjdu=YfNjgLFsLTztAwyg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Joe Perches <joe@perches.com>,
        Martin Persson <martin.persson@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 7:57 AM, Barry Song <21cnbao@gmail.com> wrote:

> has this been ready for 3.1? we have been planning to write pinmux
> driver based on this framework.

On Mon, Aug 8, 2011 at 4:28 AM, Barry Song <21cnbao@gmail.com> wrote:

> What is the status of pincfg subsystem? what's the plan about merging
> this subsystem?

I failed, we needed feedback from some more players.
If you need this framework, please review and ACK the
patch set when you're happy with it so I know I have users who
are happy with it as it looks.

v4 is out today atleast. If there are no big objections so I have to
re-architect it again, I might be able to ask Stephen to pull it
into linux-next.

Thanks,
Linus Walleij
