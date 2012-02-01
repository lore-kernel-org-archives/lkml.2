Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2BAIQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:16:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43472 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2BAIQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:16:20 -0500
Date: Wed, 1 Feb 2012 00:16:18 -0800
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: tegra: Switch to new pinctrl driver
Message-ID: <20120201081618.GJ7399@quad.lixom.net>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
 <1327083746-31430-3-git-send-email-swarren@nvidia.com>
 <CACRpkdZ_hBviswq7pXoLozC8gjzvowCBrj9yjw1xJT79b5rtwQ@mail.gmail.com>
 <CAOesGMjuewhO2H+QFQtAX+xFb5hyNn8Q65Cuup4vaXWAFvX87w@mail.gmail.com>
 <CACRpkdayNsOFkOwLZNO_pJnNmM=NmSZhkJtAwkHxQvHovdF0uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdayNsOFkOwLZNO_pJnNmM=NmSZhkJtAwkHxQvHovdF0uw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 12:13:06AM +0100, Linus Walleij wrote:
> On Tue, Jan 24, 2012 at 11:44 PM, Olof Johansson <olof@lixom.net> wrote:
> 
> > Yup, I've just been waiting on things to settle,
> > bindings/implementation wise. Will look at it over the next day or two
> > and get back.
> 
> The only bindings you need to look into for this patch set should be
> for the driver itself, the other muxmap bindings discussion I would
> *very* much like to keep orthogonal to the review of this driver.

Yup, it's more that I grouped the discussions together mentally and passed on
all of them for a while. :)

> I'm pretty scared of how device tree bindings seem to suck in
> every discussion like a black hole and then explode in a myriad
> fragmented discussions like a supernova :-P

Yeah, welcome to the ugly side of device trees. Some things are easier and
nicer to do there. Some things... are not.


-Olof
