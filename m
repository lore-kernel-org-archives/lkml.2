Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0IBPyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:54:53 -0400
Received: from sati.usurf.usu.edu ([129.123.194.129]:44087 "EHLO
	echo.usurf.usu.edu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0IBPyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:54:52 -0400
From: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: Memory allocation modifications in ibm_newemac driver AND sil24
 driver
Thread-Topic: Memory allocation modifications in ibm_newemac driver AND
 sil24 driver
Thread-Index: AQHLSrcshfsM6eFwGUOA3D27zMVHJw==
Date: Thu, 2 Sep 2010 15:54:50 +0000
Message-ID: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC12822018@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2F09@Mercury.usurf.usu.edu>
	 , <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2FBE@Mercury.usurf.usu.edu>	 ,
 <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A301B@Mercury.usurf.usu.edu>
	 <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A305B@Mercury.usurf.usu.edu>
 <1283401130.16240.9.camel@pasglop>
In-Reply-To: <1283401130.16240.9.camel@pasglop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.31.40.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o82Ft86o015153

>> Can anyone explain to me why I would be getting this error in the
>> first place?  Why is it failing to allocate a page when there are
>> pages available?  That does not make any sense to me.

> order:1

> It's failing to allocate -two- pages.

Good point.  However, why is it failing?  According to the dump, there are 28 8k pages available.

>From doing more testing yesterday, I found that this error is also coming up from the SATA driver as well (sil24).  Again with those errors, it fails allocating a page of order 0, when there are a few hundred of those available.  What is up with the VMM?  Why are pages failing to allocate when they are available?

Thanks,

Jonathan


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
