Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab0DJFPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 01:15:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35151
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab0DJFPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 01:15:21 -0400
Date: Fri, 09 Apr 2010 22:15:25 -0700 (PDT)
Message-Id: <20100409.221525.164947216.davem@davemloft.net>
To: cristiklein@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: add setsockopt to disable slow start after idle
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100409.221307.246951787.davem@davemloft.net>
References: <1270863015-19597-1-git-send-email-cristiklein@gmail.com>
	<20100409.221307.246951787.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And BTW you should CC: netdev@vger.kernel.org for all networking
patches.  Sending it only to linux-kernel makes it not reach
most of the networking developers.
