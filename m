Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab1FLRtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 13:49:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:17118 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1FLRtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 13:49:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,355,1304319600"; 
   d="scan'208";a="12619964"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 12 Jun 2011 20:49:38 +0300
Subject: RE: mei driver breaks suspend on 3.0git
Thread-Topic: mei driver breaks suspend on 3.0git
Thread-Index: Acwo8eqpJEt4YMkQR6eFRjTcGf1wVwANRioQAABx1hA=
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401AD318AB4@hasmsx504.ger.corp.intel.com>
References: <201106121314.26394.a.miskiewicz@gmail.com>
 <F28B59AD52D84B479DCA469824475335065FFB592A@hasmsx503.ger.corp.intel.com>
In-Reply-To: <F28B59AD52D84B479DCA469824475335065FFB592A@hasmsx503.ger.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5CHnupK006718



> -----Original Message-----
> From: Weil, Oren jer
> Sent: Sunday, June 12, 2011 8:36 PM
> To: Arkadiusz Miskiewicz
> Cc: Winkler, Tomas; linux-kernel@vger.kernel.org
> Subject: RE: mei driver breaks suspend on 3.0git
> 
> >It's thinkpad t400 with
> >00:03.0 Communication controller [0780]: Intel Corporation Mobile 4 Series
> >Chipset MEI Controller [8086:2a44] (rev 07)
> 
> Can you send us more details? Does it happened in stress? How do I
> reproduce
> it?
> Can you send us the debug prints?

You  need enable dynamic debug printouts in kernel .config

CONFIG_DYNAMIC_DEBUG=y

and
echo "module mei +p" >/sys/kernel/debug/dynamic_debug/control

Thanks
Tomas

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
