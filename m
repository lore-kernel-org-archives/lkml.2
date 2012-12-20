Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2LTQt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:49:58 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39553 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2LTQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:49:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121220163814.GA29557@quad.lixom.net>
References: <20121220163814.GA29557@quad.lixom.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Dec 2012 08:49:30 -0800
X-Google-Sender-Auth: 6LRJnEyqvq4s9vgjraL1mEX_TmI
Message-ID: <CA+55aFxL47wxTyTzLdnoFV=trnrMAz=_7rhsQFjb+K_mvTCa9w@mail.gmail.com>
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
To: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, maxime.ripard@free-electrons.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 8:38 AM, Olof Johansson <olof@lixom.net> wrote:
>
> One of the sunxi patches from the last pull request was misapplied (I
> realized what happened -- git am -s didn't apply cleanly so I had done it
> through regular patch, thus not catching the renames properly). Here's
> a fresh version of the pull request with a couple more OMAP and Samsung
> patches included.

Argh!

I pulled your earlier branch due to Tony's ack, and now you're
re-created that branch with new pulls (effectively rebasing it).

Don't do things like this to me.

                Linus
