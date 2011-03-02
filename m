Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab1CBDSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:18:40 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:41340 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757620Ab1CBDSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:18:39 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Ben Dooks'" <ben-i2c@fluff.org>
Cc: "'Jean Delvare'" <khali@linux-fr.org>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Seth Heasley'" <seth.heasley@intel.com>,
        "'Linus Walleij'" <linus.walleij@stericsson.com>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>
References: <1298956583-3734-1-git-send-email-tomoya-linux@dsn.okisemi.com> <4D6D91B7.5070209@fluff.org>
Subject: RE: [PATCH v3] i2c-eg20t: support new device OKI SEMICONDUCTOR ML7213 IOH
Date: Wed, 2 Mar 2011 12:18:35 +0900
Message-ID: <9B1A3736CA9445A9A96F14E0B8ED18B1@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcvYclCULtj1bA7WR0WBpG4CpRF35QAFRyfw
In-Reply-To: <4D6D91B7.5070209@fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wednesday, March 02, 2011 9:39 AM, Ben Dooks wrote:
> Ok, will apply to i2c-next.
Thank you for your applying.

> > +/* Definition for ML7213 by OKI SEMICONDUCTOR */
> > +#define PCI_VENDOR_ID_ROHM		0x10DB
> > +#define PCI_DEVICE_ID_ML7213_I2C	0x802D
> 
> we should get this moved to a pci header file at somepoint.
Do you mean include/linux/pci_ids ?


> > +		strcpy(pch_adap->name, KBUILD_MODNAME);
> 
> really should be strlcpy() and ensure that the string length is used.
OK.
We will update in next update.


> > -	pch_i2c_init(&adap_info->pch_data);
> > +		pch_i2c_init(&adap_info->pch_data[i]);
> > +	}
> >   	ret = request_irq(pdev->irq, pch_i2c_handler, IRQF_SHARED,
> > -		  KBUILD_MODNAME,&adap_info->pch_data);
> > +		  KBUILD_MODNAME, adap_info);
> 
> how about using dev_name() of the platform device to register 
> these things?
Sorry, I can't understand your saying.
Could you explain in more detail ? 

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

