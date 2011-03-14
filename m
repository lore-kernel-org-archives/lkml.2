Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab1CNVrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:47:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43391
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101Ab1CNVrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:47:05 -0400
Date: Mon, 14 Mar 2011 14:47:43 -0700 (PDT)
Message-Id: <20110314.144743.232749141.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: wrong index used in inner loop
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D768917.9040605@gmail.com>
References: <4D768917.9040605@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: roel <roel.kluin@gmail.com>
Date: Tue, 08 Mar 2011 20:52:55 +0100

> Index i was already used in the outer loop.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

CAN maintainers, could you please review and ACK patches in a timely manner,
especially utterly trivial bug fixes like this one here?

That's largely what I've been waiting for, a simple sign of life from the
listed maintainers for these files.

Anyways, no use waiting any longer, applied, thanks Roel.
