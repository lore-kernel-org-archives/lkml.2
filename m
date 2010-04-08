Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab0DHUNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:13:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59568
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758758Ab0DHUNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:13:02 -0400
Date: Thu, 08 Apr 2010 13:13:04 -0700 (PDT)
Message-Id: <20100408.131304.166360041.davem@davemloft.net>
To: tony.luck@intel.com
Cc: timo.teras@iki.fi, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: powerpc boot failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <o2s12c511ca1004081155o9b28c9f5hdfadd075913f1fcf@mail.gmail.com>
References: <20100408174549.2f45ceea.sfr@canb.auug.org.au>
	<4BBD966D.8020404@iki.fi>
	<o2s12c511ca1004081155o9b28c9f5hdfadd075913f1fcf@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o38KDfmE020446

From: Tony Luck <tony.luck@intel.com>
Date: Thu, 8 Apr 2010 11:55:34 -0700

> I tried the patch you just posted.  Compiling with it gave this warning:
> 
> net/xfrm/xfrm_policy.c: In function ¡__xfrm_lookup¢:
> net/xfrm/xfrm_policy.c:1735: warning: ¡num_xfrms¢ may be used
> uninitialized in this function

This is just because gcc is stupid, you can ignore this.

It can't see that when a real 'err' error is returned we never end up
referencing the num_xfrms value.

> but the patched kernel booted ok.

Thanks for testing, I pushed Timo's fix to net-next-2.6 earlier today
so it'll hopefully show up in the next linux-next.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
