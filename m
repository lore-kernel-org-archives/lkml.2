Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1EISrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:47:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57010
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445Ab1EISri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:47:38 -0400
Date: Mon, 09 May 2011 11:47:06 -0700 (PDT)
Message-Id: <20110509.114706.189685729.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] tulip: logging cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1304733889.git.joe@perches.com>
References: <cover.1304733889.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri,  6 May 2011 19:08:41 -0700

> Joe Perches (4):
>   tulip: xircom_cb: Convert #ifdef DEBUG blocks and enter/leave uses
>   tulip: Convert printks to netdev_<level>
>   tulip: Convert uses of KERN_DEBUG
>   tulip: Use pr_<level> where appropriate

With the advent of the function tracer, those silly function entry/exit
logging things are entirely superfluous.

They make the code look ugly too.

So you have my approval to just kill those things off entirely.

Please do that and respin this patch set, thanks Joe!
