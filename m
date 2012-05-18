Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967110Ab2ERXUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:20:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35659 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2ERXUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:20:01 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vuA9A6X5qBt+maej2vaJCgLcHvYfqfXRGD+sKAYt4Bnw@mail.gmail.com>
References: <CACxGe6vuA9A6X5qBt+maej2vaJCgLcHvYfqfXRGD+sKAYt4Bnw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 May 2012 16:19:39 -0700
X-Google-Sender-Auth: XEHE52QxoljDeYOZzSR1NkH0UEM
Message-ID: <CA+55aFxXrX5QboJXYDM2G0sG3xf4Fx19snaMgPRknRsmTOJRKg@mail.gmail.com>
Subject: Re: [GIT PULL] GPIO build failure bug fix
To: Grant Likely <grant.likely@secretlab.ca>, Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 1:04 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> GPIO build failure bug
>
> The gpio pch9 patch merged for v3.4-rc7 has a build failure when built
> as a module because it is an interrupt controller and the symbols it
> needs aren't exported.  This branch restricts it to being built in to
> solve the issue until it can be fixed properly in v3.5.

Umm.  They got exported by commit 3911ff30f5d1. So this bugfix seems stale.

Or is there something else going on too?

                   Linus
