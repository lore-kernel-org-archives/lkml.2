Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901Ab0HLLdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:33:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54645 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759877Ab0HLLdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=onnV+vGu6cIbK7XORnka9Dg+gUHpcZDvponFQ0dHNW1a/BZj2OfxASKnoiq5rnU31J
         UQ5yfKT2Mw4mwfdDCkm9XjQcLnFk44d4KHOboOqumLe0Ynnhvl0B63Re4T6lTLJNcfdN
         bqMoAQK14Ffq+F7dyD6tsU+wtH2ti8v0jgpS0=
MIME-Version: 1.0
In-Reply-To: <3e2dabb188e85bde4b942193be4414e53c604e04.1281365237.git.m.nazarewicz@samsung.com>
References: <cover.1281365237.git.m.nazarewicz@samsung.com>
	<49ebe5a39e05aa55a19d33a2141736d215873f86.1281365237.git.m.nazarewicz@samsung.com>
	<b4fe56570ecb77ec6acbab4502f7ad87b72885e1.1281365237.git.m.nazarewicz@samsung.com>
	<9219d2c4e7b60f2ad1455b6c702604e84ef90e1b.1281365237.git.m.nazarewicz@samsung.com>
	<fd2e70a236743436c0c2e88eb3b32e4564571e32.1281365237.git.m.nazarewicz@samsung.com>
	<e37b282da3898486df3fc33cbb1de5e1b6bc26c3.1281365237.git.m.nazarewicz@samsung.com>
	<dadbebba90720630077702d19240acca9fdb2182.1281365237.git.m.nazarewicz@samsung.com>
	<1a8a7e76daf68acaeecf4334848703318355a3a2.1281365237.git.m.nazarewicz@samsung.com>
	<3e2dabb188e85bde4b942193be4414e53c604e04.1281365237.git.m.nazarewicz@samsung.com>
Date: Thu, 12 Aug 2010 14:33:41 +0300
Message-ID: <AANLkTi=RBuXMgAohF1=1eNwZh791Q0CgX60CHUsBrBTK@mail.gmail.com>
Subject: Re: [PATCHv7 8/8] usb: gadget: mass_storage: optional SCSI WRITE FUA bit
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 6:02 PM, Michal Nazarewicz
<m.nazarewicz@samsung.com> wrote:
> The nofua parameter (optionally ignore SCSI WRITE FUA) was added
> to the File Storage Gadget some time ago.  This patch adds the
> same functionality to the Mass Storage Function.
>
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> +               rc = device_create_file(&curlun->dev, &dev_attr_nofua);
> +               if (rc)
> +                       goto error_luns;
It has the same issue as my original patch - forgot to remove device node.

-- 
With Best Regards,
Andy Shevchenko
