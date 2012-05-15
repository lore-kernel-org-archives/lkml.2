Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445Ab2EOPlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:41:39 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:60848 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965299Ab2EOPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:41:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1337096465!11670687!42
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Tue, 15 May 2012 10:41:23 -0500
Subject: RE: [PATCH] staging: comedi: refactor ni_pcimio driver and use
 module_comedi_pci_driver
Thread-Topic: [PATCH] staging: comedi: refactor ni_pcimio driver and use
 module_comedi_pci_driver
Thread-Index: Ac0yje7eHE8lBCr2TZqSVupaqJXjcgAIqgtg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698AE0932@AUSP01VMBX24.collaborationhost.net>
References: <201205111651.56541.hartleys@visionengravers.com>
 <4FB23DF8.8090508@mev.co.uk>
In-Reply-To: <4FB23DF8.8090508@mev.co.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4FFfv3O012317

On Tuesday, May 15, 2012 4:29 AM, Ian Abbott wrote:
> On 2012-05-12 00:51, H Hartley Sweeten wrote:
>> +static struct comedi_driver ni_pcimio_driver = {
>> +	.driver_name	= "ni_pcimio",
>
> The original used the DRV_NAME macro expanding to "ni_pcimio" here...
>
>> +static struct pci_driver ni_pcimio_pci_driver = {
>> +	.name		= "ni_pcimio",
>
> ... which could also be used here.
>
>  (I realize this is a bit late as the patch is already committed!)

I noticed that. A couple of the comedi drivers do this but it's not consistent.

Personally I don't care for the use of the DRV_NAME (or DRIVER_NAME
or whatever someone wants to call it) usage. It doesn't same any code
space and always makes me have to do a second search to see what the
"name" actually is.

Regardsless, if you prefer this in the drivers please let me know. It
would be nice to have them somewhat consistent before the comedi
support leaves staging.

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
