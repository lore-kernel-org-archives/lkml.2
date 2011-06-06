Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1FFV5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:57:45 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:6839 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab1FFV5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:57:44 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1307397458!28049539!13
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joe Perches <joe@perches.com>, cocci <cocci@diku.dk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
Date: Mon, 6 Jun 2011 16:57:31 -0500
Subject: RE: [RFC] Convert "resource->end - resource->start + 1" to
 resource_size(resource) via coccinelle
Thread-Topic: [RFC] Convert "resource->end - resource->start + 1" to
 resource_size(resource) via coccinelle
Thread-Index: AcwklBoUmB7F+AXyQS+Q6q4T6zgwlgAACcZg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
References: <201106061349.00474.hartleys@visionengravers.com>
 <1307397174.4994.26.camel@Joe-Laptop>
In-Reply-To: <1307397174.4994.26.camel@Joe-Laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p56Lvro0009718

On Monday, June 06, 2011 2:53 PM, Joe Perches wrote:
> On Mon, 2011-06-06 at 13:49 -0700, H Hartley Sweeten wrote:
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Dan Williams <dan.j.williams@intel.com> (supporter:ASYNCHRONOUS TRAN...)
>> Cc: Vinod Koul <vinod.koul@intel.com> (supporter:DMA GENERIC OFFLO...)
>
> Perhaps do a treewide update via:
>
> $ cat resource.cocci
> @@
> struct resource *ptr;
> @@
>
> - ptr->end - ptr->start + 1
> + resource_size(ptr)
>
> $ spatch -sp_file resource.cocci linux-2.6/

Joe,

I think most of the offenders were caught back in late 2009.

I found a couple old patches that I submitted back then that were never acked
so I just updated and reposted them.

Also, I have never looked at coccielle... ;-)

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
