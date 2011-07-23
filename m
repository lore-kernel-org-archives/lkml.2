Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1GWVR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 17:17:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374Ab1GWVRW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 17:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <1311408223.3499.13.camel@localhost>
References: <1311408223.3499.13.camel@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 23 Jul 2011 14:17:00 -0700
Message-ID: <CA+55aFwy-oWnJ1Mp_7m-Myrfm_W3cysacirRhjXohxzQyTgK8Q@mail.gmail.com>
Subject: Re: [GIT PULL] OpenRISC architecture
To: Jonas Bonn <jonas@southpole.se>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 1:03 AM, Jonas Bonn <jonas@southpole.se> wrote:
>
> NOTE:  This pull depends on a patch "modules: add default loader hook
> implementations" in Rusty's tree... without that, the OpenRISC arch will
> not build.  Note also that there are a couple of patches that touch
> asm-generic bits at the base of the branch, including a patch from
> Andrew that was moved to this branch to avoid a merge conflict.

So I don't want to pull this if it doesn't build. Rusty, what's the
status of your module tree?

                    Linus
