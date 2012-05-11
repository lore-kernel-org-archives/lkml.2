Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2EKReU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:34:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:8490 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab2EKReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:34:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1336757658!5242928!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Fri, 11 May 2012 12:34:14 -0500
Subject: RE: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
Thread-Topic: [PATCH] staging: comedi: Add helper macro for comedi pci
 driver boilerplate
Thread-Index: Ac0vnAbV8jOKo4axReiQ6qxadcUpvAAAAwfA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17E6A@AUSP01VMBX24.collaborationhost.net>
References: <201205111007.46754.hartleys@visionengravers.com>
 <4FAD4D20.1010302@mev.co.uk>
In-Reply-To: <4FAD4D20.1010302@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4BHYOPk020643

On Friday, May 11, 2012 10:32 AM, Ian Abbott wrote:
> On 2012-05-11 18:07, H Hartley Sweeten wrote:
>> +int comedi_pci_driver_register(struct comedi_driver *comedi_driver,
>> +		struct pci_driver *pci_driver)
>> +{
>> +	int ret;
>> +
>> +	ret = comedi_driver_register(comedi_driver);
>> +	if (ret<  0)
>> +		return ret;
>> +
>> +	pci_driver->name = comedi_driver->driver_name;
>
> I think it would be better if the driver modules that call this function 
> already had pci_driver->name initialized statically.

I agree, but this is how all the pci drivers do it now.

To change this will require auditing all the comedi pci drivers and adding
the static name.

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
