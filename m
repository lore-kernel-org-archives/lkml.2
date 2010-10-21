Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0JUKQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:16:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43792
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755801Ab0JUKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:15:59 -0400
Date: Thu, 21 Oct 2010 03:16:22 -0700 (PDT)
Message-Id: <20101021.031622.70194403.davem@davemloft.net>
To: mcuos.com@gmail.com
Cc: netdev@vger.kernel.org, yachen@nuvoton.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/nuc900: change dev_warn to dev_dbg when link down
 occurs
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CB86C87.5010207@gmail.com>
References: <4CB86C87.5010207@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wan ZongShun <mcuos.com@gmail.com>
Date: Fri, 15 Oct 2010 23:00:23 +0800

> Hi David,
> 
> When I didnot connect the net cable, the warning infos are always
> showed,
> so I change the dev_warn to dev_dbg.
> 
> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

Your patch does not apply to the current tree.
