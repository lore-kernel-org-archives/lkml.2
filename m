Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0I2Utc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:49:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54741
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab0I2Utb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:49:31 -0400
Date: Wed, 29 Sep 2010 13:49:52 -0700 (PDT)
Message-Id: <20100929.134952.15245176.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: roel.kluin@gmail.com, netdev@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [XFRM]: Don't dereference error pointer dst1
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285793113.5211.8.camel@edumazet-laptop>
References: <4CA3BFA3.1060204@gmail.com>
	<1285793113.5211.8.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 29 Sep 2010 22:45:13 +0200

> This is not a dereference, but a cast from "struct xfrm_dst *" to
> "struct dst_entry *"

Right, please teach whatever tool caught this that taking an address
of a member of an object referenced by pointer is not an error like a
true dereference is.
