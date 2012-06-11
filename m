Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2FKIop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:44:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61767 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2FKIom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:44:42 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-70-4fd5aff93b71
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Randy Dunlap'" <rdunlap@xenotime.net>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'USB list'" <linux-usb@vger.kernel.org>, devel@driverdev.osuosl.org,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Mike Lockwood'" <lockwood@android.com>
References: <4FD10A30.50707@xenotime.net>
 <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org>
Subject: RE: linux-next: Tree for Jun 7 (staging/ccg #2)
Date: Mon, 11 Jun 2012 10:44:28 +0200
Message-id: <000001cd47ae$6d482a60$47d87f20$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1E8Ga7zqjtvh3sRkmIUoN7T+nbAACvboOQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAd2f66/6G+zdLWpxedccNouDC9sY
	LRYta2V2YPb4vEkugDGKyyYlNSezLLVI3y6BK+PLtEusBf/ZKs4c/cXewHiVtYuRk0NCwETi
	xZN/zBC2mMSFe+vZuhi5OIQEFjFKtK5eywzh/GSUmLSmGayKTcBYYu/BDkYQW0QgVKJhyXKw
	DmaBqUwSs6ZfYQNJCAnkSPybeRWoiIODU8BX4le3CUhYWMBConFhKytImEVAVWLFYxWQMK+A
	tUTT3OdMELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGUGaZUQUJd49FcX4gIjiVvHpjNDlIhI
	3G14zjqBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh/Yz
	qR2MKxssDjEKcDAq8fA2LL3qL8SaWFZcmXuIUYKDWUmEd1sFUIg3JbGyKrUoP76oNCe1+BCj
	NAeLkjhvk/UFfyGB9MSS1OzU1ILUIpgsEwenVAMjr/T5vgcR5p8K5RmCnHc/LZ5X9nnPxkm7
	byqpJTz39DHVnaPlUj2lMXu9bfztiyIFjjkvHz18zrhg72kBry98OzyelU/e5yl71t5V/bic
	x63K/YXC3gdYFz54u6H3T63wlMv/zzG+CvpTkm13pafqXs1NxZ1ppX5sAVGZFRVbcpPsXj3m
	kPusxFKckWioxVxUnAgAT4mTQWkCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, June 07, 2012 10:59 PM Alan Stern wrote:

<snip>
> 
> The problems above are caused by the fact that
> drivers/staging/ccg/Kconfig does not make USB_G_CGG dependent on BLOCK.

@Randy: Thanks for finding it.

@Alan: Thanks for suggesting a solution.

> 
> > In file included from drivers/staging/ccg/ccg.c:59:0:
> > drivers/staging/ccg/../../usb/gadget/f_fs.c: At top level:
> > drivers/staging/ccg/../../usb/gadget/f_fs.c:40:0: warning: "pr_vdebug"
> redefined
> > drivers/staging/ccg/../../usb/gadget/u_serial.c:138:0: note: this is the
> location of the previous definition
> 
> This could be fixed by adding a #ifndef guard to f_fs.c and u_serial.c.
> It's a little awkward to combine independent source files this way.
> 
@Randy: Thanks for finding it.

@Alan: Thanks for suggesting a solution.

The patches are on their way.

Andrzej


