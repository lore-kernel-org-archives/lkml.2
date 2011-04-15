Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab1DOSHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:07:15 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:35921 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab1DOSHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:07:14 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: irq allocation for pci drivers
Thread-Topic: irq allocation for pci drivers
Thread-Index: Acv5bA6y3omTgUXWSZGM+Uf9MemaiwAWy52AAHQehRA=
Date: Fri, 15 Apr 2011 18:07:12 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481CBBD5@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <6E21E5352C11B742B20C142EB499E0481CB17E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110413034043.GA813@suse.de>
In-Reply-To: <20110413034043.GA813@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.78]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3FI7Oug028811



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, April 12, 2011 11:41 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: Re: irq allocation for pci drivers
> 
> On Tue, Apr 12, 2011 at 11:57:22PM +0000, KY Srinivasan wrote:
> > Greg,
> 
> Anyway, I have no idea, please use 'git bisect' to track down the
> problem commit that causes this.

Greg,

This problem turned out to be on the host side. We don't have any issue with dynamic
irq allocation on the win2k8 r2 hosts. Some older hosts have an issue and in any event
it does not look like it is a  Linux issue.

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
