Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935472Ab0KQUWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:22:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33143
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935179Ab0KQUWg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:22:36 -0500
Date: Wed, 17 Nov 2010 12:23:01 -0800 (PST)
Message-Id: <20101117.122301.233699121.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: segoon@openwall.com, kernel-janitors@vger.kernel.org, eilong@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bnx2x: fix error value sign
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289766728.2743.147.camel@edumazet-laptop>
References: <1289765315-6028-1-git-send-email-segoon@openwall.com>
	<1289766583.2743.144.camel@edumazet-laptop>
	<1289766728.2743.147.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 14 Nov 2010 21:32:08 +0100

> Le dimanche 14 novembre 2010 à 21:29 +0100, Eric Dumazet a écrit :
> 
>> I remember sending same patch in the past... it was lost somehow...
> 
> Ah, it was another issue, patch was not lost ;)

:-)  Applied, thanks everyone.
