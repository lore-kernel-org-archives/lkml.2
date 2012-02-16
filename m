Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2BPUAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:00:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52340 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2BPUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:00:29 -0500
MIME-Version: 1.0
In-Reply-To: <4F3CBE3F.1090604@nvidia.com>
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
	<1329114588-15430-3-git-send-email-ldewangan@nvidia.com>
	<20120213211809.GI11077@ponder.secretlab.ca>
	<CACRpkdZzcN5oi0ejeTQn3BNJ_w6XHsBQ_RoQMvpf8Lt2bOARAg@mail.gmail.com>
	<4F3CBE3F.1090604@nvidia.com>
Date: Thu, 16 Feb 2012 21:00:28 +0100
Message-ID: <CACRpkdaFyxU-gq5ETnNc4LonTo98PbUs09CmvsPUqzyt0Mg2Cg@mail.gmail.com>
Subject: Re: [PATCH V1 2/3] Documentation: gpio: Add details of open-drain configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "dunlap@xenotime.net" <dunlap@xenotime.net>, "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 9:28 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Yes, I can add the open source also but like to be in incremental change.
> Not together with open drain.
> We can go with:
> - open drain core driver support.
> - open drain sysfs interface support
> - open source core driver support
> - open source sysfs interface.
>
> I have already changes for the first 2 which we can review/apply,
> Meanwhile I will work on open source support.
>
> Does it look good?

Well as a patch concept it is OK but I have real bad feelings about
patch  [2/4] and [4/4] adding sysfs.

What the GPIO subsystem really needs is to get rid of sysfs
interfaces, have them deprecated and replaced with a
per-gpiochip /dev/gpioN with ioctl()s or similar instead. The sysfs
interface is just ... it won't scale.

Yours,
Linus Walleij
