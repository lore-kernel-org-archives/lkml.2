Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1JONYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 09:24:08 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:45858 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1JONYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 09:24:07 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
 staging
Thread-Topic: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out
 of staging
Thread-Index: AQHMiv2KcmQwABJKa0ij2IuJiEaIS5V9aPAA///71bA=
Date: Sat, 15 Oct 2011 13:24:05 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA0FE18@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1318658907-16698-1-git-send-email-kys@microsoft.com>
 <1318660596.6035.27.camel@Joe-Laptop>
In-Reply-To: <1318660596.6035.27.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9FDOHY1024621



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Saturday, October 15, 2011 2:37 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> dmitry.torokhov@gmail.com; linux-input@vger.kernel.org; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
> staging
> 
> On Fri, 2011-10-14 at 23:08 -0700, K. Y. Srinivasan wrote:
> > In preparation for moving the mouse driver out of staging, seek community
> > review of the mouse driver code.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Just some stylistic things, none of which should
> prevent any code movement.

Thanks Joe. I will fix the issues you have noted either before or after
moving the code out of staging based on other review comments.

Regards,

K. Y 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
