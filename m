Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2HFOmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:42:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34362 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab2HFOmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120806143016.GK16861@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
	<20120806143016.GK16861@opensource.wolfsonmicro.com>
Date: Mon, 6 Aug 2012 22:42:12 +0800
Message-ID: <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 10:30 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Aug 06, 2012 at 12:32:48AM +0800, Haojian Zhuang wrote:
>
>> Since IORESOURCE_IO is used for PCI devices, it doesn't fit on
>> 88PM860x PMIC device that lies on I2C bus. So use IORESOURCE_MEM
>> instead.
>
> This isn't much more appropriate - _MEM is for memory ranges so isn't
> directly relevant to register addresses either.  If anything _IO is
> slightly nearer.

I use register resource to distinguish different components now. For
example, component driver
needs to access the registers in PMIC. These registers offsets are set
in 88pm860x-core.c.
So I think that it may not be called _IO.

Regards
Haojian
