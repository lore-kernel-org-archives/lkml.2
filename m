Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab0IPCbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 22:31:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58338
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab0IPCbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 22:31:07 -0400
Date: Wed, 15 Sep 2010 19:31:25 -0700 (PDT)
Message-Id: <20100915.193125.149817205.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, samuel@sortiz.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/15] irda/irnet: use noop_llseek
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284495763-7506-9-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
	<1284495763-7506-9-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 14 Sep 2010 22:22:36 +0200

> There may be applications trying to seek
> on the irnet character device, so we should
> use noop_llseek to avoid returning an error
> when the default llseek changes to no_llseek.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
