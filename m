Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2HYI1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:27:55 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63770 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212Ab2HYI1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:27:43 -0400
MIME-Version: 1.0
In-Reply-To: <201208242153.24638.tweek@tweek.dk>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208242035.38733.tweek@tweek.dk>
	<CAJ7jCmmuxiWegxkdAsbtCbv-zXgmt--V2bVdENkupGTwj=3HSg@mail.gmail.com>
	<201208242153.24638.tweek@tweek.dk>
Date: Sat, 25 Aug 2012 10:27:41 +0200
Message-ID: <CAJ7jCmkhetET-NpSOPtphKs9Mq-FTXZQK2Di=RMHo+6Zcewn9w@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: wbrana <wbrana@gmail.com>
To: Martin Nybo Andersen <tweek@tweek.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> I know he's not giving any names, however he's specific enough: Apps which
> can't be recompiled. Ie. software for which you haven't got the source code
> or
> a working compiler.
Software used by 99% users will have alternative software which have
source code available or have 64-bit version.

> Try telling Torvalds he couldn't create Linux, or Stallman that he couldn't
> create GNU.
Chromium 22 is much more complex than Linux 1.0
linux-1.0.tar.bz2 - 20 contributors - size 1 MB
chromium-22.0.1229.14.tar.bz2 - size 200 MB

> Quite the opposite. You should try it some day. The only thing I miss is
> VDPAU. But then again, I use another computer for watching movies. It has a
> Radeon card installed (using the open radeon driver -- not the flgrx). Full
> HD
> and sound via HDMI running flawlessly. As does the integrated Intel GPU on
> my
> eeepc 900 (the CPU seems to be the fastest chip on that netbook ... ;-)
Open source drivers are black listed by Chromium because of instability
file software_rendering_list.json:
NVIDIA cards with nouveau drivers in Linux are crash-prone
The Intel Mobile 945 Express family of chipsets is not compatible with WebGL
Intel mesa drivers are crash-prone
ATI/AMD cards with third-party drivers in Linux are crash-prone
Drivers are unreliable for Optimus on Linux

http://www.phoronix.com/scan.php?page=article&item=intel_ivy_gpushow&num=10
Geforce 9800 GT with nouveau has worse performance than Ivy Bridge.
Radeon 6770 with open source drivers has far worse performance than Ivy Bridge.
There is no discrete Ivy Bridge graphics card.
