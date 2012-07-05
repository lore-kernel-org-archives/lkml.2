Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab2GENIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:08:55 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38416 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab2GENIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:08:53 -0400
MIME-Version: 1.0
In-Reply-To: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 5 Jul 2012 10:08:52 -0300
Message-ID: <CAOMZO5BQuJzAYPe+B792aNYv+xew3O0wp-UOjwggV28MbSZr9w@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device registration
From: Fabio Estevam <festevam@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jul 3, 2012 at 8:59 AM, Lee Jones <lee.jones@linaro.org> wrote:
> We register the ab8500 as an MFD device from db8500 code during Device Tree
> boot in order to solve some limitations of DT. However, when Device Tree is
> not enabled, we still want to allow platform code to register the ab8500 in
> the normal way. Here we force MFD device registration of the ab8500 only
> when booting with Device Tree enabled.
>
> Solves this issue:
> WARNING: at fs/sysfs/dir.c:526 sysfs_add_one+0x88/0xb0()
> sysfs: cannot create duplicate filename '/bus/platform/devices/ab8500-core.0'

Does the following patch fix your issue?
http://www.spinics.net/lists/arm-kernel/msg182827.html

Regards,

Fabio Estevam
