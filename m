Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0FXOIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:08:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58759 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0FXOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=dSQnHYnNRUGouwnE7PuzsiDzK4zAgod+E/LKnBvV5EWnk4YIG1u0z0MuRLu5edzFg/
         OgpN5KKM5O7oMSnzUSwGtpp2nGsGR5PrI2Da43SYC1XwB7rfy3ubEwGtx6ItIubjByWb
         b47nEpqrepZJ+oE2aXv07tCyT38eCrioxPNzs=
Date: Thu, 24 Jun 2010 18:08:44 +0400
From: =?KOI8-R?Q?=E9=CC=D8=D1_=EC=CF=C7=C9=CE=CF=D7?= <zerone2@gmail.com>
To: Ilya Loginov <isloginov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] fix problem with reschenduling in rest_init
 (2.6.35-rc3)
Message-Id: <20100624180844.61c8aa2b.zerone2@gmail.com>
In-Reply-To: <20100624172334.ca7e9bef.isloginov@gmail.com>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	<1277385096.1875.974.camel@laptop>
	<20100624172334.ca7e9bef.isloginov@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5OE95im027390

On Thu, 24 Jun 2010 17:23:34 +0400
Ilya Loginov <isloginov@gmail.com> wrote:

> Strange, but init does not die after I did this. Fix me if I wrong, but it wants
> to have pid 1, and die in other case.
> 
> Interesting...

Yeah, of course, I am wrong. To make it clear I watched sources of sysvinit and
founded out that if pid not equal to 1 init does

exit(telinit(p, argc, argv));

So, it does not die. Anyway, I would have kernel panic.

-- 
éÌØÑ ìÏÇÉÎÏ× <zerone2@gmail.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
