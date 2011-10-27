Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1J0NZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:25:44 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:49329 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1J0NZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:25:42 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Topic: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Index: AQHMk/Yfbv94uVs6kUmFh5QHJPmlm5WQdjQA//+5GHA=
Date: Thu, 27 Oct 2011 13:25:41 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA51C59@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1319645321-9770-1-git-send-email-kys@microsoft.com>
 <20111027103714.GA13732@aepfle.de>
In-Reply-To: <20111027103714.GA13732@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.19]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9RDPnT8023682



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, October 27, 2011 6:37 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> dmitry.torokhov@gmail.com; jkosina@suse.cz
> Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> 
> On Wed, Oct 26, K. Y. Srinivasan wrote:
> 
> > +static struct  hv_driver mousevsc_drv = {
> > +	.name = "mousevsc",
> 
> This should be KBUILD_MODNAME.

Thanks Olaf. Once I get some more comments (especially from Jiri), I will re-spin this patch
addressing all the comments I have gotten to date.

Regards,

K. Y 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
