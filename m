Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697Ab2COSHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:07:54 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:8605 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2COSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:07:49 -0400
From: "Clark, Liz" <liz.clark@hp.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 15 Mar 2012 18:06:42 +0000
Subject: RE: [PATCH] TTY: Wrong unicode value copied in con_set_unimap()
Thread-Topic: [PATCH] TTY: Wrong unicode value copied in con_set_unimap()
Thread-Index: Ac0C1eojg1gIuiObQka8kZ2Ri6ZGrAAAECIA
Message-ID: <51D3961FBAB878428126A3DD5A715A3A60EA909444@GVW1338EXA.americas.hpqcorp.net>
References: <1331832809-4484-1-git-send-email-liz.clark@hp.com>
 <20120315180312.GC26442@kroah.com>
In-Reply-To: <20120315180312.GC26442@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2FI7wpA005677


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, March 15, 2012 11:03 AM
> To: Clark, Liz
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] TTY: Wrong unicode value copied in
> con_set_unimap()
> 
> On Thu, Mar 15, 2012 at 10:33:29AM -0700, Liz Clark wrote:
> > Bugzilla 40012: PIO_UNIMAP bug: error updating Unicode-to-font map
> 
> What bugzilla are you referring to here?  bugs.gentoo.org?  :)


https://bugzilla.kernel.org/show_bug.cgi?id=40012


Liz
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
