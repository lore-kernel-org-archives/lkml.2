Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab0ECWIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:08:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47488
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757312Ab0ECWIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:08:22 -0400
Date: Mon, 03 May 2010 15:08:29 -0700 (PDT)
Message-Id: <20100503.150829.254849182.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] first round of vhost-net enhancements for net-next
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100503.150729.00474027.davem@davemloft.net>
References: <20100503213244.GA16006@redhat.com>
	<20100503.150729.00474027.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o43M8YmE015975

From: David Miller <davem@davemloft.net>
Date: Mon, 03 May 2010 15:07:29 -0700 (PDT)

> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Tue, 4 May 2010 00:32:45 +0300
> 
>> The following tree includes a couple of enhancements that help vhost-net.
>> Please pull them for net-next. Another set of patches is under
>> debugging/testing and I hope to get them ready in time for 2.6.35,
>> so there may be another pull request later.
> 
> Pulled, thanks.

Nevermind, reverted.

Do you even compile test what you send to people?

drivers/net/macvtap.c: In function ¡macvtap_ioctl¢:
drivers/net/macvtap.c:713: warning: control reaches end of non-void function

You're really batting 1000 today Michael...
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
