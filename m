Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab1FWAAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:00:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56648 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab1FWAAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:00:09 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-a9-4e02820061f6
Date: Thu, 23 Jun 2011 08:59:52 +0900
From: Sangbeom Kim <sbkim73@samsung.com>
Subject: RE: [PATCH 1/3] mfd: Add S5M8751 register definitions
In-reply-to: <20110622124222.GC23666@sirena.org.uk>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Message-id: <016c01cc3138$7eca0480$7c5e0d80$@com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acww2dgw3hXh2NGbRxCsStFGZ1m8dgAXbCYg
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
 <1308722037-6966-2-git-send-email-sbkim73@samsung.com>
 <20110622124222.GC23666@sirena.org.uk>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jun 22, 2011 at 09:42PM +0900, Mark Brown wrote:
> These don't look like register definitions:

OK, I will move it,
> 
> I posted a series earlier this week which adds a generic API for
> handling register maps on I2C/SPI devices - I'll post another version of
> it shortly, it'd be nice if you could loook to see if this is usable for
> you.
> 
Thanks for your comments.
After check the your patch, I will remake S5M8751 patch.

> > +/* S5M8751 internal interrupts */
> > +int s5m8751_register_irq(struct s5m8751 *s5m8751, int irq,
> > +			void (*handler) (struct s5m8751 *, int, void *),
> > +			void *data);
> > +
> > +int s5m8751_free_irq(struct s5m8751 *s5m8751, int irq);
> > +int s5m8751_mask_irq(struct s5m8751 *s5m8751, int irq);
> > +int s5m8751_unmask_irq(struct s5m8751 *s5m8751, int irq);
> > +int s5m8751_clear_irq(struct s5m8751 *s5m8751);
> 
> You should use genirq for this, it's supported this for quite some time
> now.  There's quite a few MFDs doing this which you can used for
> examples.
OK I will check it.


> > +/* S5M8751 sysfs functions */
> > +int s5m8751_uvlo_get(struct s5m8751 *s5m8751);
> > +int s5m8751_uvlo_set(struct s5m8751 *s5m8751, int voltage);
> > +
> > +int s5m8751_audio_dev_register(struct s5m8751 *s5m8751,
> > +						const char *name,
> > +						struct platform_device
**pdev);
> 
> These shouldn't need to be in the header.
OK, I will modify it.

Thanks and regards,

