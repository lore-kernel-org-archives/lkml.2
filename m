Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1BOSwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:52:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38448
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994Ab1BOSww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:52:52 -0500
Date: Tue, 15 Feb 2011 10:53:28 -0800 (PST)
Message-Id: <20110215.105328.71128043.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: add missing framebuffer_release in error path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297762502.4049.2.camel@phoenix>
References: <1297762502.4049.2.camel@phoenix>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 15 Feb 2011 17:35:02 +0800

> This patch fixes a memory leak in the error path.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
