Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0HDEgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:36:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57399
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496Ab0HDEf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:35:58 -0400
Date: Tue, 03 Aug 2010 21:36:16 -0700 (PDT)
Message-Id: <20100803.213616.48488045.davem@davemloft.net>
To: weil@mail.berlios.de
Cc: netdev@vger.kernel.org, chaithrika@ti.com, srk@ti.com,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] davinci_emac: Fix use after free in davinci_emac_remove
From: David Miller <davem@davemloft.net>
In-Reply-To: <1280861625-4804-1-git-send-email-weil@mail.berlios.de>
References: <1280861625-4804-1-git-send-email-weil@mail.berlios.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weil <weil@mail.berlios.de>
Date: Tue,  3 Aug 2010 20:53:45 +0200

> free_netdev finally calls kfree which makes the contents
> of ndev and priv (private data contained in ndev) invalid.
> 
> So iounmap should be called before free_netdev.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Chaithrika U S <chaithrika@ti.com>
> Cc: Sriramakrishnan <srk@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>

I'll apply this, thanks.
