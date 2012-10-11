Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2JKPgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:36:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45976 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab2JKPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:36:48 -0400
Date: Thu, 11 Oct 2012 16:36:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121011153643.GF15428@gmail.com>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
 <CAH9NwWe+s1p73Jwa=s5aY_KjGS2nvP8LR2YH3i5gtpFMUYMiuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH9NwWe+s1p73Jwa=s5aY_KjGS2nvP8LR2YH3i5gtpFMUYMiuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Christian Gmeiner wrote:

> 2012/10/11 Lee Jones <lee.jones@linaro.org>:
> > From: Jonas Aaberg <jonas.aberg@stericsson.com>
> >
> > The overhead is very low and the results will be found under
> > sysfs/bootime, as well as detailed results in debugfs under
> > boottime/. The bootgraph* files are compatible with
> > scripts/bootgraph.pl. The reason for this patch is to provide
> > data (sysfs/boottime) suitable for automatic testcases as
> > well as help for developers to reduce the boot time (debugfs).
> >
> 
> Nice idea... what about x86?

What about it?

You want to extend the functionality to include it? :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
