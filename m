Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab0GMESm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:18:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37423
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab0GMESl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:18:41 -0400
Date: Mon, 12 Jul 2010 21:18:56 -0700 (PDT)
Message-Id: <20100712.211856.24591640.davem@davemloft.net>
To: joe@perches.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/36] drivers/sbus: Remove unnecessary casts of
 private_data
From: David Miller <davem@davemloft.net>
In-Reply-To: <135e39325e4dd5c7fc4ac9481575ab03c6ce04f6.1278967121.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
	<135e39325e4dd5c7fc4ac9481575ab03c6ce04f6.1278967121.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 12 Jul 2010 13:50:08 -0700

> Signed-off-by: Joe Perches <joe@perches.com>

Applied.

Looks like we need a pattern for drivers/sbus in MAINTAINERS, I'll add it.
