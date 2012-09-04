Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2IDJbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:31:47 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:55592 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2IDJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:31:45 -0400
Date: Tue, 4 Sep 2012 12:31:42 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/4] i2c: introduce i2c-cbus driver
Message-ID: <20120904093142.GB855@harshnoise.musicnaut.iki.fi>
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
 <1346703805-31598-2-git-send-email-aaro.koskinen@iki.fi>
 <20120904090506.GA12397@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904090506.GA12397@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 12:05:07PM +0300, Felipe Balbi wrote:
> > + * CBUS I2C driver for Nokia Internet Tablets.

[...]

> this version misses the entire IRQ handling we already had on linux-omap
> tree, so it's quite a regression.

There's no interrupts used in plain CBUS protocol/communication I think?

But Retu MFD supports the GPIO IRQ. I added the code for this set. And
the power button driver (patch 4/4) is using this functionality:

# cat /proc/interrupts
[...]
204:         29      GPIO  retu-mfd
224:         29      RETU  retu-pwrbutton

A.
