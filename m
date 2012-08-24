Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815Ab2HXRF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:05:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55011 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758491Ab2HXRFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:05:55 -0400
MIME-Version: 1.0
In-Reply-To: <201208241854.45656.tweek@tweek.dk>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208241814.16862.tweek@tweek.dk>
	<5037AAB0.6040102@genband.com>
	<201208241854.45656.tweek@tweek.dk>
Date: Fri, 24 Aug 2012 19:05:53 +0200
Message-ID: <CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: wbrana <wbrana@gmail.com>
To: Martin Nybo Andersen <tweek@tweek.dk>
Cc: Chris Friesen <chris.friesen@genband.com>,
        Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> What I'd hate even more is rendering my old working hardware useless by
> removing x86-32 support from the kernel. To reason the removal by saying
> "Microsoft plans to do it" just makes me go bonkers...
Your old hardware will work fine with long term kernel.

> These legacy apps will most likely be compiled for x86-32 and not x32 (an
> argument for not removing x86-32 support on a running x86-64 kernel).
Which legacy apps do you mean?
