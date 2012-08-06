Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2HFPqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:46:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44803 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756443Ab2HFPqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:46:21 -0400
Date: Mon, 6 Aug 2012 16:46:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: sameo@linux.intel.com, rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120806154619.GO16861@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
 <20120806143016.GK16861@opensource.wolfsonmicro.com>
 <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 10:42:12PM +0800, Haojian Zhuang wrote:
> On Mon, Aug 6, 2012 at 10:30 PM, Mark Brown

> > This isn't much more appropriate - _MEM is for memory ranges so isn't
> > directly relevant to register addresses either.  If anything _IO is
> > slightly nearer.

> I use register resource to distinguish different components now. For
> example, component driver
> needs to access the registers in PMIC. These registers offsets are set
> in 88pm860x-core.c.

I understand this.

> So I think that it may not be called _IO.

Right, but _MEM isn't terribly relevant either.  If anything _IO is a
bit better as ioports are *somewhat* similar to registers.
