Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2BOUfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:35:21 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60380 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2BOUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:35:18 -0500
Date: Wed, 15 Feb 2012 15:35:03 -0500 (EST)
Message-Id: <20120215.153503.788456242769079702.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, yoshihiro.shimoda.uh@renesas.com,
        nobuhiro.iwamatsu.yj@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] renesas/sh_eth.c: fix linux/interrupt.h included twice
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329328483-4682-1-git-send-email-danny.kukawka@bisect.de>
References: <1329328483-4682-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 12:35:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Wed, 15 Feb 2012 18:54:43 +0100

> Remove double include of linux/interrupt.h.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
