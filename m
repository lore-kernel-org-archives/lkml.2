Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1BHTlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:41:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57012
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185Ab1BHTlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:41:13 -0500
Date: Tue, 08 Feb 2011 11:41:49 -0800 (PST)
Message-Id: <20110208.114149.104062266.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: ffb: fix ffb_probe error path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297177125.2343.3.camel@phoenix>
References: <1297177125.2343.3.camel@phoenix>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 08 Feb 2011 22:58:45 +0800

> Current implementation calls of_iounmap for par->fbc twice in error path.
> In the case of goto out_unmap_dac, we should call of_iounmap for par->dac.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Good spotting:

Acked-by: David S. Miller <davem@davemloft.net>
