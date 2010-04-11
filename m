Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab0DKFQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 01:16:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37411
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110Ab0DKFQO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 01:16:14 -0400
Date: Sat, 10 Apr 2010 22:16:18 -0700 (PDT)
Message-Id: <20100410.221618.226789099.davem@davemloft.net>
To: nm127@freemail.hu
Cc: socketcan@hartkopp.net, eric.dumazet@gmail.com,
       oliver.hartkopp@volkswagen.de, urs.thuermann@volkswagen.de,
       socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.34-rc3 + CAN build problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BC15AC7.3010904@freemail.hu>
References: <4BC070E0.6070601@hartkopp.net>
	<20100410.155009.66184583.davem@davemloft.net>
	<4BC15AC7.3010904@freemail.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Németh Márton <nm127@freemail.hu>
Date: Sun, 11 Apr 2010 07:14:47 +0200

> David Miller wrote:
>> From: Oliver Hartkopp <socketcan@hartkopp.net>
>> Date: Sat, 10 Apr 2010 14:36:48 +0200
>> 
>>> So i wonder why Nemeth trapped into this problem ... probably an include file
>>> mix-up?
>> 
>> Do you have CONFIG_DEBUG_STRICT_USER_COPY_CHECKS enabled in your
>> kernel config?
> 
> CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y

Just turn that off in your builds, it's for developers who want
to work on correcting those warnings, not you :-)
