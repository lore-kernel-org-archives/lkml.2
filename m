Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1JMVFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:05:41 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1JMVFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:05:39 -0400
Date: Thu, 13 Oct 2011 17:05:36 -0400 (EDT)
Message-Id: <20111013.170536.562162672545514574.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cy82c693: fix PCI device selection
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110131229.09178.bzolnier@gmail.com>
References: <201110121652.10495.bzolnier@gmail.com>
	<20111012.150207.1100668688848833225.davem@davemloft.net>
	<201110131229.09178.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 14:05:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 13 Oct 2011 12:28:54 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH v2] cy82c693: fix PCI device selection
> 
> Wrong PCI device may be selected by cy82c693_set_pio_mode() if modular
> IDE host drivers are used and there are additional IDE PCI devices
> installed in the system.  Fix it.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
