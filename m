Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2DYQcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:32:48 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:50765 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2DYQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:32:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1335371545!9680264!50
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Armin Schindler <armin@melware.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "isdn@linux-pingi.de" <isdn@linux-pingi.de>
Date: Wed, 25 Apr 2012 11:32:40 -0500
Subject: RE: [PATCH] isdn/eicon: use standard __init,__exit function markup
Thread-Topic: [PATCH] isdn/eicon: use standard __init,__exit function markup
Thread-Index: Ac0ir2j6xo++feD9QUCJhVaGE0svbgAUU64Q
Message-ID: <ADE657CA350FB648AAC2C43247A983F002069887E98F@AUSP01VMBX24.collaborationhost.net>
References: <201204241556.03516.hartleys@visionengravers.com>
 <4F979E33.4010703@melware.de>
In-Reply-To: <4F979E33.4010703@melware.de>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3PGWvvh008125

On Tuesday, April 24, 2012 11:48 PM, Armin Schindler wrote:
> What is the reason for this change?
>

General maintainability.

It seems a bit strange to have the long winded custom defines for the
__init and __exit.  If there is a reason behind this please ignore the
patch.

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
