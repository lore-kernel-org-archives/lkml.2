Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab0FPUgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:36:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36538
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab0FPUga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:36:30 -0400
Date: Wed, 16 Jun 2010 13:36:42 -0700 (PDT)
Message-Id: <20100616.133642.112602306.davem@davemloft.net>
To: vst@vlnb.net
Cc: sparclinux@vger.kernel.org, simone.ricci@gmail.com,
       scst-devel@lists.sourceforge.net, jeykholt@cisco.com,
       linux-kernel@vger.kernel.org
Subject: Re: How to printk/sprintf uint64_t on Sparc without format and
 argument types mismatch
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C192113.7030101@vlnb.net>
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com>
	<4C192113.7030101@vlnb.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5GKaoim011034

From: Vladislav Bolkhovitin <vst@vlnb.net>
Date: Wed, 16 Jun 2010 23:08:03 +0400

> We in SCST project need to printk/sprintf variables of type
> uint64_t. Size of those variables is required to be 64-bit integer. On
> x86 we printk/sprintf them as %lld, but on Sparc we have a compiler
> warnings like:
> 
> scst/src/scst_targ.c:2136: warning: format ¡%llx¢ expects type ¡long
> long unsigned int¢, but argument 4 has type ¡uint64_t¢.
> 
> It is because on Sparc uint64_t defined as unsigned long, but on x86 -
> as unsigned long long.

You must use %ll and explicitly cast the argument to "long long".
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
