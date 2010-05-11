Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab0EKOol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:44:41 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:15449 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0EKOok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:44:40 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
Subject: RE: [PATCH 1/1] staging: hv: Optimize adj_guesttime function and
 add more detailed comments
Thread-Topic: [PATCH 1/1] staging: hv: Optimize adj_guesttime function and
 add more detailed comments
Thread-Index: AQHK8GxLqokTG3dHi0SQCMmChJ3HS5JLzwgAgACAoiA=
Date: Tue, 11 May 2010 14:44:36 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72662AA5C3@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF72662AA29C@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <1273536158.20514.31.camel@Joe-Laptop.home>
In-Reply-To: <1273536158.20514.31.camel@Joe-Laptop.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4BEj6aS026745

> Just a couple of style nits.
> 
> return at the end of a void function() is unnecessary.
Thank you for pointing this out.
I'll update the patch soon.

- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
