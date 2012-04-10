Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2DJI44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:56:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56944 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2DJI4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:56:54 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120410084346.GF3149@opensource.wolfsonmicro.com>
References: <1334038367.15859.12.camel@phoenix> <20120410084346.GF3149@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 10 Apr 2012 16:56:34 +0800
Message-ID: <CAF+7xW=Rfj8vtoTCy7szgYpEMw1nW0HVR64b4mgJtjCoBbGi4A@mail.gmail.com>
Subject: Re: [linux-next][PATCH] regmap: fix build error if !CONFIG_DEBUG_FS
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/10 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Apr 10, 2012 at 02:12:47PM +0800, Axel Lin wrote:
>> Fix build error introduced by commit 9eba4d
>> "regmap: fix compilation when !CONFIG_DEBUG_FS".
>
> I've no idea what tree you're testing against but Stephen's fix is
> needed for -next.

I'm testing with today's linux-next tree.
It's strange in today's linux-next tree that "git show 79c64d5" can
show the commit,
but git log cannot find commit 79c64d5.

Regards,
Axel
