Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0FAHRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:17:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59593
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603Ab0FAHR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:17:28 -0400
Date: Tue, 01 Jun 2010 00:17:38 -0700 (PDT)
Message-Id: <20100601.001738.58446032.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
       netdev@vger.kernel.org
Subject: Re: [PATCH 20/21] net/ipv6/mcast.c: Remove unnecessary kmalloc
 casts
From: David Miller <davem@davemloft.net>
In-Reply-To: <52b8781064af8d4b1051f5ac175f7b7f175ff1ed.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
	<52b8781064af8d4b1051f5ac175f7b7f175ff1ed.1275360951.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 31 May 2010 20:23:22 -0700

> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
