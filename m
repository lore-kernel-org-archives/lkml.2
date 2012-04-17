Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2DQSti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:49:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34860 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2DQStg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <1334483574-3997-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334483574-3997-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 17 Apr 2012 11:49:35 -0700
X-Google-Sender-Auth: ts0JJgy1rdSuO3T2XnPlb4Ws650
Message-ID: <CA+8MBbJGZRKemR+p95B0nZt95TVb3+BxeJPRnP1dJ=EvGxWBXA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
From: Tony Luck <tony.luck@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 2:52 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Rather than requiring architectures that use gpiolib but don't have any
> need to define anything custom to copy an asm/gpio.h provide a Kconfig
> symbol which architectures must select in order to include gpio.h and
> for other architectures just provide the trivial implementation directly.

ia64 parts:

Acked-by: Tony Luck <tony.luck@intel.com>
