Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2FGVoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:44:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2FGVoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:44:00 -0400
Date: Thu, 07 Jun 2012 14:43:58 -0700 (PDT)
Message-Id: <20120607.144358.1732928576389957779.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com, tarbal@gmail.com
Cc: rkagan@parallels.com, stable@vger.kernel.org, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        peter.p.waskiewicz.jr@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, dnelson@redhat.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000: save skb counts in TX to avoid cache misses
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FD11F49.5060805@gmail.com>
References: <b838d871c0d507787373061e4edd91a624d62475.1339073391.git.rkagan@parallels.com>
	<4FD11F49.5060805@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <tarbal@gmail.com>
Date: Thu, 07 Jun 2012 14:38:17 -0700

> Thanks! I have applied the patch to my queue

Why?

My impression is that this is a patch already in the tree, and it's
being submitted for -stable but such minor performance hacks are
absolutely not appropriate for -stable submission.
