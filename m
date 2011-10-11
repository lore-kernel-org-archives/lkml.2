Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1JKTUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:20:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34316 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1JKTUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:20:44 -0400
Date: Tue, 11 Oct 2011 15:20:40 -0400 (EDT)
Message-Id: <20111011.152040.662786307819949300.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cy82c693: fix PCI device selection
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110111937.32501.bzolnier@gmail.com>
References: <201110111937.32501.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 11 Oct 2011 12:20:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 11 Oct 2011 19:37:32 +0200

> While at it remove redundant pci_get_slot() call as cy82c693_init_one()
> already takes care of keeping the reference on the second port's PCI
> device.

Please do not submit unrelated changes with a bug fix, and as IDE is
in long-term maintainence I would not accept a risky refinement like
this anyways.
