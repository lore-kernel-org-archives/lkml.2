Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1F3LQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:16:32 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:63763 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1F3LQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:16:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110630074301.GC27959@flint.arm.linux.org.uk>
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com>
	<20110630074301.GC27959@flint.arm.linux.org.uk>
Date: Thu, 30 Jun 2011 19:16:24 +0800
Message-ID: <BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com>
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause OOPS
From: Qin Dehua <qindehua@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        dan.j.williams@intel.com, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2ffe2da3e follows v2.6.32, the message is from kernel build on
commit 2ffe2da3e.

The config has CONFIG_BUG=y and CONFIG_DEBUG_BUGVERBOSE=y, but the
message is Oops, not BUG() macro, so they don't have line number.

Regards,
QinDehua

2011/6/30, Russell King <rmk@arm.linux.org.uk>:
> These traces are from 2.6.32... And I assume have CONFIG_BUG unset
> because you have no verbose bug reporting (it's not reporting the
> file/line which is necessary to identify which BUG has been hit in
> the raid code.)
>
> Could you reproduce with CONFIG_BUG=y please?
>
> --
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
>
