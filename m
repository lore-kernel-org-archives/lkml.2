Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab0JZRCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:02:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50362
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760112Ab0JZRCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:02:00 -0400
Date: Tue, 26 Oct 2010 10:02:23 -0700 (PDT)
Message-Id: <20101026.100223.48514032.davem@davemloft.net>
To: nikai@nikai.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: sgiseeq: fix return on error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101026184505.077246a2@absol.kitzblitz>
References: <20101026184505.077246a2@absol.kitzblitz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Kaiser <nikai@nikai.net>
Date: Tue, 26 Oct 2010 18:45:05 +0200

> If we continue on error, we'd likely free the IRQ that we
> didn't get, right?
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Yep, applied, thank you.
