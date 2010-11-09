Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0KIRWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:22:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37278
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab0KIRWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:22:47 -0500
Date: Tue, 09 Nov 2010 09:23:11 -0800 (PST)
Message-Id: <20101109.092311.59687219.davem@davemloft.net>
To: joe@perches.com
Cc: trivial@kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 36/39] net/ipv4/tcp.c: Update WARN uses
From: David Miller <davem@davemloft.net>
In-Reply-To: <2afee732758b93d7464e6bb07a52b3bc67f164a4.1288471898.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
	<2afee732758b93d7464e6bb07a52b3bc67f164a4.1288471898.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 30 Oct 2010 14:08:53 -0700

> Coalesce long formats.
> Align arguments.
> Remove KERN_<level>.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
