Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab0GSI5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 04:57:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760216Ab0GSI53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 04:57:29 -0400
Date: Mon, 19 Jul 2010 10:57:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: trivial: remove no longer working email address
In-Reply-To: <20100718123730.GG30716@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.1007191057160.4741@pobox.suse.cz>
References: <20100311190047.GB27619@elf.ucw.cz> <alpine.LNX.2.00.1003151525170.18642@pobox.suse.cz> <20100718123730.GG30716@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jul 2010, Pavel Machek wrote:

> On Mon 2010-03-15 15:25:42, Jiri Kosina wrote:
> > On Thu, 11 Mar 2010, pavel@ucw.cz wrote:
> > 
> > > pavel@suse.cz address is no longer working email address, remove its
> > > traces. (And yes, it means I'm looking for a job.)
> > 
> > Could you please rebase the patch on top of some more recent kernel?
> > 
> > error: patch failed: Documentation/zh_CN/sparse.txt:22
> > error: Documentation/zh_CN/sparse.txt: patch does not apply
> > error: drivers/leds/leds-input.c: does not exist in index
> > error: patch failed: kernel/power/main.c:3
> > error: kernel/power/main.c: patch does not apply
> > error: kernel/power/sleepy.c: does not exist in index
> 
> Done, you should have newer version in the mail.

I have applied it, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
